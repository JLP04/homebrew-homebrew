class Libticalcs < Formula
  desc "TiCalcs library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/e5ad813ccf8bae71de6aa344df020178698b57b3.tar.gz"
  version "1.1.10"
  sha256 "0d4489cc697ad27785edc835364e5830a1970282f720d9c6090e29faaae1ca7f"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 ventura:      "ab4e06f5b3f1f774cd15330aa58d85df1f0df1c3fbb55eb4a7c748033e241c63"
    sha256 monterey:     "3ff6c5e902775f64e99c153476ff09217632ce602baff007e8354fdf9082fc71"
    sha256 x86_64_linux: "fcc0d8478a0819faafd89dddfe1496e5b0eb9feadaa869ec874ef4fca9aec4fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "libarchive" => :test
  depends_on "glib"
  depends_on "libticables"
  depends_on "libticonv"
  depends_on "libtifiles"

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
