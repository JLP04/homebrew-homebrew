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
    rebuild 4
    sha256 arm64_tahoe:   "10769c44ef4721b1556ee6e61a824883e5c7aef6f417375e577e84e5c615cb61"
    sha256 arm64_sequoia: "50c15be5187e8ed8649a73487f71f8da5565b247e59b9eb47de2bba7044e7100"
    sha256 arm64_sonoma:  "92dbdefad7e423955757e1bd484aa6e9cb5b0274348d0aaeb36f3ff20e51aff1"
    sha256 arm64_linux:   "9ad8cedfb7b3cda51453ee9f2bc39ea43c158f9d49620abce56436185c1e4b6c"
    sha256 x86_64_linux:  "ae13fe995bd9ffa5423e2fa7b5c7c68745d77f647866f0ddf7a22977082088ea"
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

  deny_network_access!

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
