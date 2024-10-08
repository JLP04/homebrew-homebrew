class Tilp < Formula
  desc "Program allowing a computer to communicate with TI graphing calculators"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/5a2ea6337c4983b80375a50e3ada1f7c45f6e9ea.tar.gz"
  version "1.19"
  sha256 "95b10e225e6a33b033891300dcc03d0f96c0eaf21c478b6f3b33e3f818d0a154"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 3
    sha256 arm64_sonoma: "54953a0fac5df54f90da766ffd759b97e219cbef3466ddafc306a4d488a50fe0"
    sha256 ventura:      "f930ff93b742fcf4b8ca5243f600acc652d1bd84e2a2f7bc8b33a94588d121b2"
    sha256 monterey:     "3ca3b329ad56c3b92d9d51ff1e11f533f0954ae820d1486e3dc9f02bb1d7c1b8"
    sha256 x86_64_linux: "b8f02f620a7f1a9c4ae78f9aa4341078bd4fdc14a59a8f8c57b71556c84ae98d"
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
  depends_on "libjpeg" => :build
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
  depends_on "pkg-config" => :build
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
      url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/B38964FB6AF244DFA4674BA19128646C/CabriJr_CE.8ek"
      sha256 "6e28f09a50293a14c49ce438d2fa336392c538d44c4b5ef18964e239825d1303"
    end

    resource("testfile2") do
      url "https://education.ti.com/download/en/ed-tech/BCBFECEC5F4242B28E9AE89DA7C4BA59/57A7BDE9179548309AB0265093B9CB27/TI84CEBundle-5.8.1.12.b84"
      sha256 "0bb80bac84b03d057180cf2460eeb59ac084a25d1cf363a3bcf5c6beebbfb511"
    end

    resource("testfile1").stage testpath
    resource("testfile2").stage testpath
    shell_output("#{bin}/tilp --help")
    shell_output("#{bin}/tilp --version")
    system bin/"tilp", "-n"
    system bin/"tilp", "-n", "--cable", "Null", "--calc", "None", "CabriJr_CE.8ek", "TI84CEBundle-5.8.1.12.b84"
  end
end
