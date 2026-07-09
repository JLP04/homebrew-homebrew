class Gfm < Formula
  desc "Group File Manager for TI handhelds"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/0a525619a07d92734b5eb5ba1d47c56f4de37458.tar.gz"
  version "1.09"
  sha256 "fd638afc5eb7104be54d465137c22fafb024cef465837691fe66234d0d429513"
  license "GPL-2.0-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 3
    sha256 arm64_tahoe:   "74fe0112438dcba2eae4884fe4e25877b9fabdd18563ff8a0b7acd5d520ecb3f"
    sha256 arm64_sequoia: "4071b877cae77f1c7a2ad83b4b148c8919e1569528fe3a2f4752cc79dd1d54a7"
    sha256 arm64_sonoma:  "28066051da4a54575bbea2973a9884d7074cb52da6b09afc840b7b254e026151"
    sha256 arm64_linux:   "bdedb977dffc61436088bb4986f596f324e872283e78f90321651b1b5e04f304"
    sha256 x86_64_linux:  "816688af73f1f49982ee2a019636e7e617052ec3b82b79e1b942dee28ab1f577"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairo" => :build
  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "fribidi" => :build
  depends_on "gettext" => :build
  depends_on "graphite2" => :build
  depends_on "harfbuzz" => :build
  depends_on "jpeg" => :build
  depends_on "libpng" => :build
  depends_on "libticables" => :build
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
  depends_on "pkgconf" => :build
  depends_on "tfdocgen" => :build
  depends_on "xorgproto" => :build
  depends_on "zstd" => :build
  depends_on "at-spi2-core"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "jlp04/homebrew/libglade"
  depends_on "libticalcs"
  depends_on "libticonv"
  depends_on "libtifiles"

  uses_from_macos "libarchive" => :build

  on_macos do
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

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
