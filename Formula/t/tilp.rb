class Tilp < Formula
  desc "Program allowing a computer to communicate with TI graphing calculators"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/4a399bc491b2d2d9fdab76d23d7cf87a43b0beec.tar.gz"
  version "1.19"
  sha256 "33347790504b25a5b33bdf64f950ff86584e7668644a5f275441348e06b763c3"
  license "GPL-2.0-or-later"
  revision 7
  compatibility_version 1
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    url "https://raw.githubusercontent.com/debrouxl/tilp_and_gfm/refs/heads/master/tilp/trunk/configure.ac"
    regex(/AC_INIT\(TILP2, (.*), \[tilp-users@lists\.sourceforge\.net\]\)/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 5
    sha256 arm64_golden_gate: "409cc9e711f16c19ed82506ad173a840ba328582f23dde6224d0ccfa127ec738"
    sha256 arm64_tahoe:       "367cbd6475d83efdf30609b807305d6935458973bc5dc2a5c86bb8359f55ff7e"
    sha256 arm64_sequoia:     "67d91d1138ea2652ddea418d7268c7d862a900ae4928e3dab72fc1d85ea689d9"
    sha256 arm64_linux:       "eb709fa3002f0be3888c4efbeda257f6bb36e67a6414e861c76b280efdd9f668"
    sha256 x86_64_linux:      "3c15c7b5639ef35ba8c90ed728831391791fc3958035c14b08b919b59bbf6ef1"
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
  depends_on "intltool" => :build
  depends_on "jpeg" => :build
  depends_on "libpng" => :build
  depends_on "libtiff" => :build
  depends_on "libtool" => :build
  depends_on "libusb" => :build
  depends_on "libx11" => :build
  depends_on "libxau" => :build
  depends_on "libxcb" => :build
  depends_on "libxdmcp" => :build
  depends_on "libxext" => :build
  depends_on "libxrender" => :build
  depends_on "pixman" => :build
  depends_on "pkgconf" => :build
  depends_on "tfdocgen" => :build
  depends_on "xorgproto" => :build
  depends_on "zstd" => :build
  depends_on "at-spi2-core"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libticables"
  depends_on "libticalcs"
  depends_on "libticonv"
  depends_on "libtifiles"
  depends_on "pango"

  uses_from_macos "libarchive" => :build

  on_macos do
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl" => :build
    depends_on "expat"
    depends_on "zlib-ng-compat"
  end

  resource "testfile1", :test do
    url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/99F094C3FF7140A998994A8BE767A2E0/CabriJr_CE_5.8.3.0048.8ek"
    sha256 "845594b672bd20f0903caa6ea93295601e802a901be3f2efdc480a3607d0eba8"
  end

  resource "testfile2", :test do
    url "https://education.ti.com/download/en/ed-tech/BCBFECEC5F4242B28E9AE89DA7C4BA59/41CFC58F1E3C4B4DA3E3B717DD34BAC3/TI84CEBundle-5.8.5.74.b84"
    sha256 "a027c822f08622e0b4393f680f8824b7601db8748a1bee6a8e3fc5e1444d1161"
  end

  deny_network_access!

  def install
    Dir.chdir("tilp/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("testfile1").stage testpath
    resource("testfile2").stage testpath
    shell_output("#{bin}/tilp --help")
    shell_output("#{bin}/tilp --version")
    system bin/"tilp", "-n"
    filenames = "CabriJr_CE_5.8.3.0048.8ek TI84CEBundle-5.8.5.74.b84".chomp.split
    system bin/"tilp", "-n", "--cable", "Null", "--calc", "None", *filenames
  end
end
