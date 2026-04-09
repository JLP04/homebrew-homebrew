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
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 arm64_tahoe:   "06ae17873986c43aae7fde2022cac8ecac4b6bd40450e36ef4340634dbc96f68"
    sha256 arm64_sequoia: "6c9d0267b8236ecebc4a2f58a039ffd3cbed8d1335e82caeef2efee086d6ba21"
    sha256 arm64_sonoma:  "1122a36c6756b9d6d279b40634ea6428489a506251827d3f8ad277c184e576ea"
    sha256 arm64_linux:   "e731052b5659dd572d4c50a7661666be9d1d8dc4c922764be8b7f5191f3f0b27"
    sha256 x86_64_linux:  "4b0c1062cc915b3e30256d4d18e223c16d61442388877a7bac317c93e87c208a"
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

  def install
    Dir.chdir("tilp/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("testfile1") do
      url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/99F094C3FF7140A998994A8BE767A2E0/CabriJr_CE_5.8.3.0048.8ek"
      sha256 "845594b672bd20f0903caa6ea93295601e802a901be3f2efdc480a3607d0eba8"
    end

    resource("testfile2") do
      url "https://education.ti.com/download/en/ed-tech/BCBFECEC5F4242B28E9AE89DA7C4BA59/B9A1D3FF707B4EB18501382FB9EFB33B/TI84CEBundle-5.8.4.58.b84"
      sha256 "5c31b462e31cd00caf3e1175aa90ca9266ac7385e49c424f19e50da8f49e8462"
    end

    resource("testfile1").stage testpath
    resource("testfile2").stage testpath
    shell_output("#{bin}/tilp --help")
    shell_output("#{bin}/tilp --version")
    system bin/"tilp", "-n"
    filenames = "CabriJr_CE_5.8.3.0048.8ek TI84CEBundle-5.8.4.58.b84".chomp.split
    system bin/"tilp", "-n", "--cable", "Null", "--calc", "None", *filenames
  end
end
