class Libticables < Formula
  desc "TiCables library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/6b05504e663b7310f77f876ef4286f504091860f.tar.gz"
  version "1.3.6"
  sha256 "d936b4adfb24f6e300d87c9999d01772cc20f2718077e8040923849c0e15dcf3"
  license "GPL-2.0-or-later"
  revision 8
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    url "https://raw.githubusercontent.com/debrouxl/tilibs/refs/heads/master/libticables/trunk/configure.ac"
    regex(/VERSION="(.*)"/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 2
    sha256 arm64_golden_gate: "db1ecb3353cf954a693f44e097e306f3b53fc998eceb7f237b10fc78713c1c8f"
    sha256 arm64_tahoe:       "d8af750c9d6bdf96d7f6d371b2c72b0be54e6b8bec9b423fac2e3150f615b11c"
    sha256 arm64_sequoia:     "a112c716d272c7da717b72ceb795ebf48b8b9b4d0c9e3516b33797a1154f7271"
    sha256 arm64_linux:       "e419daf20cb680ca694e4cec78779bada59d69980831381bd729bffd5f9958b8"
    sha256 x86_64_linux:      "64112ce90e2db21f00802eab9e5014d5e152df8e3c883f6b7fe6517b4323ec12"
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

  deny_network_access!

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
