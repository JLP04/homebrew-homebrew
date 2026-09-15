class Libticalcs < Formula
  desc "TiCalcs library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/6dba390e7390c4b98ae96287b39a3971c331fbef.tar.gz"
  version "1.1.10"
  sha256 "c6c37882b73e86d6bee6f9b253976479491ab4956fbf5e556e3a585c66c94a50"
  license "GPL-2.0-or-later"
  revision 13
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 arm64_golden_gate: "9a643aa0dba4a2d5f79d174201e4a2f374e0ac275e82cd04a4758469f76e644a"
    sha256 arm64_tahoe:       "ea4a0031e9306376b7aea06e22ec2cc1668d203bec365a4a978debf4698d70dd"
    sha256 arm64_sequoia:     "caead0c26175805e433e1f4f08aba09a3ce94dd6555670ae3f215d0f57087c52"
    sha256 arm64_linux:       "8b251e59eae6d673dbfac34dcdabbb01528ccf1b6c9ca80d5f3b0c9d0daa0a42"
    sha256 x86_64_linux:      "e1acbea222b7607443e48279930d2794206aeee624b04e6321d10f77672b80ed"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libticables"
  depends_on "libticonv"
  depends_on "libtifiles"

  uses_from_macos "libarchive" => :test

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    Dir.chdir("libticalcs/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <glib.h>
      #include <ticables.h>
      #include <tifiles.h>
      #include <ticalcs.h>

      static void print_lc_error(int errnum)
      {
        char *msg;

        ticables_error_get(errnum, &msg);
        fprintf(stderr, "Link cable error (code %i)...\\n<<%s>>\\n", errnum, msg);

        g_free(msg);
      }

      int main()
      {
        CableHandle* cable;
        CalcHandle* calc;
        int err;

        // init libs
        ticables_library_init();
        ticalcs_library_init();
        ticalcs_version_get();

        // set cable
        cable = ticables_handle_new(CABLE_NUL, PORT_2);
        if (cable == NULL)
          return -1;

        // set calc
        calc = ticalcs_handle_new(CALC_TI83);
        if (calc == NULL)
          return -1;

        // attach cable to calc (and open cable)
        err = ticalcs_cable_attach(calc, cable);

        err = ticalcs_calc_isready(calc);
        if (err)
          print_lc_error(err);
        printf("Hand-held is %sready !\\n", err ? "not " : "");

        // detach cable (made by handle_del, too)
        err = ticalcs_cable_detach(calc);

        //remove calc & cable
        ticalcs_handle_del(calc);
        ticables_handle_del(cable);

        return 0;
      }
    EOS
    ENV["PKG_CONFIG_PATH"] = "#{formula_opt_lib("libarchive")}/pkgconfig"
    flags = shell_output("pkg-config --cflags --libs ticalcs2").chomp.split
    flags_cables = shell_output("pkg-config --cflags --libs ticables2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, *flags_cables, "-o", "test"
    system "./test"
  end
end
