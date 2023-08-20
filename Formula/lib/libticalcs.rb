class Libticalcs < Formula
  desc "TiCalcs library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/f2d61881844c28a14eef27df5e1798cdcc1ec873.tar.gz"
  version "1.1.10"
  sha256 "2ba36dc3ce22837004878e9b8a98d351e176d5f57fe8be23c10e6da2eff339f9"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 monterey:     "df51519e68694765587a317298f17ff5535ed750beba1372601f511a0123acb5"
    sha256 big_sur:      "d185fc54702f0b6c7bf81c66d819982f69ebf32dcecf27ddbdf4b3e54878d076"
    sha256 x86_64_linux: "0092a706a312f1da107c3d40a1cba508cdc82bd2046c21ad74d401692591a7c3"
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

  # Fix error about invalid use of non-static member 'data'
  # Issue ref: https://github.com/debrouxl/tilibs/issues/80#issuecomment-1685296325
  on_macos do
    patch :DATA
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
__END__
diff --git a/libticalcs/trunk/src/dusb_vpkt.cc b/libticalcs/trunk/src/dusb_vpkt.cc
index e1e55c0..67557cc 100644
--- a/libticalcs/trunk/src/dusb_vpkt.cc
+++ b/libticalcs/trunk/src/dusb_vpkt.cc
@@ -365,10 +365,10 @@ TIEXPORT3 int TICALL dusb_set_buf_size(CalcHandle* handle, uint32_t size)
 {
 	VALIDATE_HANDLE(handle);
 
-	if (size > sizeof(DUSBRawPacket::data) + 1)
+	if (size > DUSB_DATA_SIZE + 1)
 	{
 		ticalcs_warning("Clamping dubious large DUSB buffer size");
-		size = sizeof(DUSBRawPacket::data) + 1;
+		size = DUSB_DATA_SIZE + 1;
 	}
 
 	handle->priv.dusb_rpkt_maxlen = size;
diff --git a/libticalcs/trunk/src/ticalcs.h b/libticalcs/trunk/src/ticalcs.h
index 95db449..e8c3802 100644
--- a/libticalcs/trunk/src/ticalcs.h
+++ b/libticalcs/trunk/src/ticalcs.h
@@ -352,6 +352,8 @@ typedef struct
 
 //! Size of the header of a \a DUSBRawPacket
 #define DUSB_HEADER_SIZE (4+1)
+//! Size of the data contained in \a DUSBRawPacket
+#define DUSB_DATA_SIZE (1023)
 
 /**
  * DUSBRawPacket:
@@ -360,10 +362,10 @@ typedef struct
  **/
 typedef struct
 {
-	uint32_t size;       ///< raw packet size
-	uint8_t  type;       ///< raw packet type
+	uint32_t size;                 ///< raw packet size
+	uint8_t  type;                 ///< raw packet type
 
-	uint8_t  data[1023]; ///< raw packet data
+	uint8_t  data[DUSB_DATA_SIZE]; ///< raw packet data
 } DUSBRawPacket;
 
 /**
