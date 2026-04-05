class Libtifiles < Formula
  desc "TiFiles library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/dab8afe0d23d146038088498dcf389ca0baabeec.tar.gz"
  version "1.1.8"
  sha256 "28c60bb9fd1942a02d3d275ddd885ae9c2e68236b3557116677e9cae979c6a36"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 4
    sha256 arm64_tahoe:   "4bdf883206ea360b3229d1943139159e1bc0e77a63f8e5a9bf8443c6f1ddf951"
    sha256 arm64_sequoia: "c3b70c368fa2cda6e1cd6381cc89f81f4106329bcb5e8803b18d327c63f62e86"
    sha256 arm64_sonoma:  "0c5a10cdd4f45030a5038e6dd26a4f8990f023f397eb66830afb494d3935302a"
    sha256 arm64_linux:   "9effbd3278f41fe6cee304f16c907f2e09e710f2430b8bfa4543606ef6e8ab5e"
    sha256 x86_64_linux:  "38934d39fb1f37b21bac449a85e9de497787768e017a57b3fd77888c392e3995"
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

  def install
    Dir.chdir("libtifiles/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("testfile") do
      url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/99F094C3FF7140A998994A8BE767A2E0/CabriJr_CE_5.8.3.0048.8ek"
      sha256 "845594b672bd20f0903caa6ea93295601e802a901be3f2efdc480a3607d0eba8"
    end

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
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/libarchive/lib/pkgconfig"
    flags = shell_output("pkg-config --cflags --libs tifiles2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
