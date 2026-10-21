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
    url "https://raw.githubusercontent.com/debrouxl/tilibs/refs/heads/master/libticalcs/trunk/configure.ac"
    regex(/VERSION="(.*)"/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 2
    sha256 arm64_golden_gate: "8cdd12c1ddbfd809ef529bdf43f6c9416a449920d00cf0f18c007aa41488b00a"
    sha256 arm64_tahoe:       "c05460a84f1d21e66adbdcea5ef26507a32cf6e02f47db6c15265b1caa9c7477"
    sha256 arm64_sequoia:     "31177d3befa1b43929764972d981ee8721b9df8b3ba9521ded0fbe2ac2542d0d"
    sha256 arm64_linux:       "be9481cf63adf656abfd38fbbda30674c16150608203b8dca44f301561023b2f"
    sha256 x86_64_linux:      "af11780052c0d60d1b49e93fc295e18056cc42739367ed7accd3db8bcf50ef31"
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
