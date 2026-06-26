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
    rebuild 5
    sha256 arm64_tahoe:   "2894003dabd5fcc40864486b38c6b58b8be477adc7ba2e1cf2e77e55b7d773d0"
    sha256 arm64_sequoia: "f6bdf90b942e5556c3b1fe98caca1a58ac1dba8bcbd1b2a114fc18637d3d881b"
    sha256 arm64_sonoma:  "634b59e183ba37c0e1757cf17ceafb02d41dcd4a48569b923c10857df250faf2"
    sha256 arm64_linux:   "ec9f57ffb913c2efc568bb07cdfccce779ac1136dff7b78cfd4b99a42cc02318"
    sha256 x86_64_linux:  "74e901c6d44401a3c3454df118d6c260f505904d34a8d5e4400283b356cc2fbf"
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
    ENV["PKG_CONFIG_PATH"] = "#{formula_opt_lib("libarchive")}/pkgconfig"
    flags = shell_output("pkg-config --cflags --libs tifiles2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
