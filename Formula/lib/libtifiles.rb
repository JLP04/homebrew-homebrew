class Libtifiles < Formula
  desc "TiFiles library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/6dba390e7390c4b98ae96287b39a3971c331fbef.tar.gz"
  version "1.1.8"
  sha256 "c6c37882b73e86d6bee6f9b253976479491ab4956fbf5e556e3a585c66c94a50"
  license "GPL-2.0-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    url "https://raw.githubusercontent.com/debrouxl/tilibs/refs/heads/master/libtifiles/trunk/configure.ac"
    regex(/VERSION="(.*)"/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 3
    sha256 arm64_golden_gate: "331a20e06d7592b8012ea3742c292eafd125114a50be3d6e9073caf8c513e24d"
    sha256 arm64_tahoe:       "6914a872b761b745a40b966cc5f2cef1ded5d7580581f9256e71906f0162347e"
    sha256 arm64_sequoia:     "d6d4a447a3529400779205d01f7bb9d3b8f42db00967038923a8389a27bffc0c"
    sha256 arm64_linux:       "92a20ee5dc27b3d7665e79d81c1b9209a618cb204cf022fc87a9049f11334496"
    sha256 x86_64_linux:      "cb0102f02e9e79652772ba71799dbfd408362fbe6146025544815c26ee0977f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "libticonv"

  on_macos do
    depends_on "gettext"
  end

  resource "testfile", :test do
    url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/99F094C3FF7140A998994A8BE767A2E0/CabriJr_CE_5.8.3.0048.8ek"
    sha256 "845594b672bd20f0903caa6ea93295601e802a901be3f2efdc480a3607d0eba8"
  end

  deny_network_access!

  def install
    Dir.chdir("libtifiles/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tilp2/tifiles.h>

      int main() {
        FlashContent *content;

        content = tifiles_content_create_flash(CALC_TI84PCE_USB);

        tifiles_library_init();
        tifiles_version_get();

        tifiles_file_read_flash("CabriJr_CE_5.8.3.0048.8ek", content);
        tifiles_file_display_flash(content);

        return 0;
      }
    EOS
    resource("testfile").stage testpath
    ENV["PKG_CONFIG_PATH"] = "#{formula_opt_lib("libarchive")}/pkgconfig"
    flags = shell_output("pkg-config --cflags --libs tifiles2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
