class Tilp < Formula
  desc "Program allowing a computer to communicate with TI graphing calculators"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/0a525619a07d92734b5eb5ba1d47c56f4de37458.tar.gz"
  version "1.19"
  sha256 "fd638afc5eb7104be54d465137c22fafb024cef465837691fe66234d0d429513"
  license "GPL-2.0-or-later"
  revision 5
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 4
    sha256 arm64_sonoma: "752ab88f645215a5ff794cd245fb96a59a39d7a76c18d0041a0aa9f171a0bfd6"
    sha256 ventura:      "0b648e44ee44893bb46b9bdf4483f819bdad5810b4a0b5383648f9b63ea66ee5"
    sha256 x86_64_linux: "9597bd1cd38343c4eeb9fb5cba2ad44294b952ff3d412848e4cc62c5aa20ebc0"
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
      url "https://education.ti.com/download/en/ed-tech/BCBFECEC5F4242B28E9AE89DA7C4BA59/030A23A7ECE14DB6A70DF859F83979C7/TI84CEBundle-5.8.2.29.b84"
      sha256 "d13f804bbd7f27e07f98b319ea82c9bf24b32fe02e6fe2025789a7e7bf199a6c"
    end

    resource("testfile1").stage testpath
    resource("testfile2").stage testpath
    shell_output("#{bin}/tilp --help")
    shell_output("#{bin}/tilp --version")
    system bin/"tilp", "-n"
    system bin/"tilp", "-n", "--cable", "Null", "--calc", "None", "CabriJr_CE.8ek", "TI84CEBundle-5.8.2.29.b84"
  end
end
