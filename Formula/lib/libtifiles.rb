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
    rebuild 2
    sha256 arm64_golden_gate: "1476795dbdf59b5bb4c95d9fb4b1f99dd4efb49b60595e3d2285571dfb31962b"
    sha256 arm64_tahoe:       "e19747ce25f23f42a5a9993a3665d376670eec2036de0a826cb2a8c7c700e4d0"
    sha256 arm64_sequoia:     "9f5514a743bbb8f0403c9bf1c5c79ffd7730f3b0509b2312e4d6102508bdeb88"
    sha256 arm64_linux:       "c913baddaeda999a5c56539c7830cf5adb3f9565e1e471766bdfae616d441502"
    sha256 x86_64_linux:      "28ee3710bd1cae2baea4ef90d9b7ff64cc0328b4aeaed9bbd854db5d6c55f26e"
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
