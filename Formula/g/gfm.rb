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
    rebuild 5
    sha256 arm64_golden_gate: "a856f0c48d0cb601287de14e1b0bd991eaf1c9625f6642665a0b19219ec1cc65"
    sha256 arm64_tahoe:       "b5eb03d53a2ac8576609e644be400e0262c2b89a1ef68735ea7d3ff8f46c6144"
    sha256 arm64_sequoia:     "18bba2af99284bc00b5afa3d6f28fd2410523343056f05efd67d25fe58034691"
    sha256 arm64_linux:       "8bf1d848da5f4978f645410ea772edca568e11adf3f8b83df81b76eb0e3b2122"
    sha256 x86_64_linux:      "60c496bc1fbff5e30546bc43527139e71a13c71295907695048859a08cb43631"
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
