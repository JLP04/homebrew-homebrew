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
    rebuild 2
    sha256 arm64_tahoe:   "e7a54944998ff8bb0911c63f8a04cd0883d0e889b7fe05c72c4fe1ece90e0076"
    sha256 arm64_sequoia: "698a83fded395dd063ed6bfaf3893e4176d28dfb2e5f2286905bd19dfc9a6e22"
    sha256 arm64_sonoma:  "30c22730622b43c381d0333e7dd308728f71f974d16076a508c8d2f5c38ceb5e"
    sha256 arm64_linux:   "d71ca9cc5b9f5004579a92840ae669e00a20a3dbd9df9dd937fdbb7dc8733e24"
    sha256 x86_64_linux:  "cfbfa404fef39c2fbe6fb91c4a071428d10060c68e1ec557cf9924925dcc6cda"
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

  # downloads test resources
  allow_network_access! :test

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
