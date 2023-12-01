class Gfm < Formula
  desc "Group File Manager for TI handhelds"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/37917438fba03778dc591f4beb8aec7f8f7c67fd.tar.gz"
  version "1.09"
  sha256 "3aff5fc2ca818efc26c4042c63b350ac5119675c8e7b49d54afe82eefe9999b8"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 monterey:     "588e18c0024ec788a5d59b801710bd31b3a8231d8970eb54943f36a7cf2bf922"
    sha256 x86_64_linux: "4423622e087fa83265a9cbdebd39794ff74200b9f3ac5fc0eb0849d7a822e847"
  end

  depends_on "at-spi2-core" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairo" => :build
  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "fribidi" => :build
  depends_on "gdk-pixbuf" => :build
  depends_on "gettext" => :build
  depends_on "glib" => :build
  depends_on "graphite2" => :build
  depends_on "gtk+" => :build
  depends_on "harfbuzz" => :build
  depends_on "libarchive" => :build
  depends_on "libjpeg" => :build
  depends_on "libpng" => :build
  depends_on "libticables" => :build
  depends_on "libticonv" => :build
  depends_on "libtiff" => :build
  depends_on "libtool" => :build
  depends_on "libusb" => :build
  depends_on "libx11" => :build
  depends_on "libxau" => :build
  depends_on "libxcb" => :build
  depends_on "libxdmcp" => :build
  depends_on "libxext" => :build
  depends_on "libxrender" => :build
  depends_on "pango" => :build
  depends_on "pcre2" => :build
  depends_on "pixman" => :build
  depends_on "pkg-config" => :build
  depends_on "tfdocgen" => :build
  depends_on "xorgproto" => :build
  depends_on "zstd" => :build
  depends_on "jlp04/homebrew/libglade"
  depends_on "libticalcs"
  depends_on "libtifiles"

  def install
    Dir.chdir("gfm/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/gfm --help")
    shell_output("#{bin}/gfm --version")
  end
end
