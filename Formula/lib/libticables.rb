class Libticables < Formula
  desc "TiCables library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/92c2d4177da5c201919662b1db3bb52e10c9b070.tar.gz"
  version "1.3.6"
  sha256 "86dd7c916ed9326b9700d5090d01b65063a59ec3e1b08dedaf0b51cb037e47c3"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 arm64_sequoia: "cc077f06e2b1fe9588a261cb77f613ecf3ac087c037f39fce09fc05d39e15290"
    sha256 arm64_sonoma:  "c9413a093f038607ce5403c23c611fde36938660406484ce885c27efd65bf701"
    sha256 ventura:       "76c6dea480afec09471b76bbbf0cdc04a59e5527d0cdd8c493c8f9b7d5de7e2d"
    sha256 x86_64_linux:  "a9245ca45f2f3589907893e0eb2a193cfbc012f43e4f918b8276ce5a39e2a74e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libusb"

  on_macos do
    depends_on "gettext"
  end

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
