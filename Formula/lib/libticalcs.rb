class Libticalcs < Formula
  desc "TiCalcs library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/791d2535813fa7ffef8f9feadf110998d4ae57fb.tar.gz"
  version "1.1.10"
  sha256 "a603e9b7424369bcffb64fd4ad6cb8ab4e187280738fc89fde2f2ca2dd46eb44"
  license "GPL-2.0-or-later"
  revision 11
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 arm64_tahoe:   "204986b049f57076d8924f7f9695f97398d967a917d7fc23f4cef9c99ff35cfa"
    sha256 arm64_sequoia: "bded4ee716579b4b3cd3b82fb00f9dbdac6ac60f5f397ff40f984b8155ef1a1b"
    sha256 arm64_sonoma:  "80b76c9f341f5a2e987badd7345478428a173a195308757060cd352dd2ac25d3"
    sha256 arm64_linux:   "f6f7eeb45f3201b5de6ea7addcf14723e7658e77ffbb2fe15f1b5ab8bd8e8063"
    sha256 x86_64_linux:  "ea451d152c385d709fcc93bbca79cf5456f2786da48c876fff1a189c5faa77c4"
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
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/libarchive/lib/pkgconfig"
    flags = shell_output("pkg-config --cflags --libs ticalcs2").chomp.split
    flags_cables = shell_output("pkg-config --cflags --libs ticables2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, *flags_cables, "-o", "test"
    system "./test"
  end
end
