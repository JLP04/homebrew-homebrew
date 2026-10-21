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
    url "https://raw.githubusercontent.com/debrouxl/tilp_and_gfm/refs/heads/master/gfm/trunk/configure.ac"
    regex(/AC_INIT\(GFM, (.*), \[tilp-users@lists\.sourceforge\.net\]\)/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 6
    sha256 arm64_golden_gate: "bb5eff122b7f7b8179990e9934d0a9105c502f1c30e7a821f18a42625fd5c81b"
    sha256 arm64_tahoe:       "cf15d70855c8dfd768422814c2357a094abd7cd2e5e5962bac0365c3042ca07f"
    sha256 arm64_sequoia:     "74b8bfd207b90f820fdbed5814f7cd938c6cc1400654c45e56b9b86e3fa2bc87"
    sha256 arm64_linux:       "e699d8a7f5059ce0017450df87fe3776926b9aa830a831f979eb2efd61b6ffbb"
    sha256 x86_64_linux:      "5a27d378f19ef4fed8dfe01210c74921c0f8568d9f33ac5d0bdb22b3e2c7f945"
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
