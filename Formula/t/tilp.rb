class Tilp < Formula
  desc "Program allowing a computer to communicate with TI graphing calculators"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/4a399bc491b2d2d9fdab76d23d7cf87a43b0beec.tar.gz"
  version "1.19"
  sha256 "33347790504b25a5b33bdf64f950ff86584e7668644a5f275441348e06b763c3"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 arm64_sequoia: "e0942c3684ca9c74d184800b2484e31016476ef14045279c6763991aa0d5cee2"
    sha256 arm64_sonoma:  "d8f27c8f61088c96f0be04a96f50f726ec162a54caad47e603d979ad9347ada5"
    sha256 x86_64_linux:  "fdac9ded54f1abf14c47995b1f25efeda500f4cef9c42fed52a4e86296d71ccb"
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
    depends_on "zlib"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
      sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("XML::Parser").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
        system "make", "install"
      end
    end
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
      url "https://education.ti.com/download/en/ed-tech/BCBFECEC5F4242B28E9AE89DA7C4BA59/98A175EF6FDF4073B5675B6DF20CE705/TI84CEBundle-5.8.3.48.b84"
      sha256 "73b65c3b71d64af731c3e63d2e8df9b3019cdbe9ef6d12795382051c112c8293"
    end

    resource("testfile1").stage testpath
    resource("testfile2").stage testpath
    shell_output("#{bin}/tilp --help")
    shell_output("#{bin}/tilp --version")
    system bin/"tilp", "-n"
    filenames = "CabriJr_CE_5.8.3.0048.8ek TI84CEBundle-5.8.3.48.b84".chomp.split
    system bin/"tilp", "-n", "--cable", "Null", "--calc", "None", *filenames
  end
end
