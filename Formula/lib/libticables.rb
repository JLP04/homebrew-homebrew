class Libticables < Formula
  desc "TiCables library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/01782c21da30fcddfbc9bdeb5ca15e12d112483a.tar.gz"
  version "1.3.6"
  sha256 "7863c45858c928d4f33208ffa8aca10d9e5fccfc2c3740d6c42d7d22550b1b53"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 ventura:      "28ee320492b87f65514a76913af2201f615ed6afeab313b5f730eae7c7b30cb4"
    sha256 monterey:     "198a880a83176ecf022d7786404eadcde05b3c6e1124f4d12fecbc91e6f74789"
    sha256 big_sur:      "fe974cdd3dc9c698fa906b2c24680eeebbc0ccb43e5c8819d5aca62e39a6946e"
    sha256 x86_64_linux: "9582aad7386390a36cf0327d655cec3e9b27d31910e4371c2b9f87358fe09139"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libusb"

  def install
    Dir.chdir("libticables/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-libusb10"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <glib.h>
      #include <ticables.h>

      static void print_lc_error(int errnum)
      {
        char *msg;

        ticables_error_get(errnum, &msg);
        fprintf(stderr, "Link cable error (code %i)...\\n<<%s>>\\n", errnum, msg);

        ticables_error_free(msg);
      }

      int main()
      {
        CableHandle *handle;
        int err, i;
        uint8_t buf[4];

        // init lib
        ticables_library_init();
        ticables_version_get();

        // set cable
        handle = ticables_handle_new(CABLE_NUL, PORT_1);
        if (handle == NULL)
          return -1;

        ticables_options_set_timeout(handle, 15);
        ticables_options_set_delay(handle, 10);
        ticables_handle_show(handle);

        // open cable
        err = ticables_cable_open(handle);
        if (err) print_lc_error(err);
        if (err) return -1;

        // do a simple test with a TI89/92+ calculator
        buf[0] = 0x08; buf[1] = 0x68; buf[2] = 0x00; buf[3] = 0x00;     // RDY
        err = ticables_cable_send(handle, buf, 4);
        if(err) print_lc_error(err);

        // display answer
        memset(buf, 0xff, 4);
        err = ticables_cable_recv(handle, buf, 4);
        if (err) print_lc_error(err);

        for(i = 0; i < 4; i++)
          printf("%02x ", buf[i]);
        printf("\\n");

        // close cable
        ticables_cable_close(handle);

        // release handle
        ticables_handle_del(handle);

        // exit lib
        ticables_library_exit();

        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs ticables2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
