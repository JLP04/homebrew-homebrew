class Tilp < Formula
  desc "Program allowing a computer to communicate with TI graphing calculators"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilp_and_gfm/archive/37917438fba03778dc591f4beb8aec7f8f7c67fd.tar.gz"
  version "1.19"
  sha256 "3aff5fc2ca818efc26c4042c63b350ac5119675c8e7b49d54afe82eefe9999b8"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/debrouxl/tilp_and_gfm.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 monterey:     "10f4cc6a4f7bca440d0c8a8716372051ab7fc1e3c3821f080a2dca817288268f"
    sha256 x86_64_linux: "61b6e478bff9baf36ba118ffbde0701ea14b58fbae2b2650363b0224598425b2"
  end

  depends_on "atk" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairo" => :build
  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "fribidi" => :build
  depends_on "gdk-pixbuf" => :build
  depends_on "gettext" => :build
  depends_on "glib" => :build
  depends_on "graphite2" => :build
  depends_on "harfbuzz" => :build
  depends_on "intltool" => :build
  depends_on "libarchive" => :build
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
  depends_on "pango" => :build
  depends_on "pixman" => :build
  depends_on "pkg-config" => :build
  depends_on "tfdocgen" => :build
  depends_on "xorgproto" => :build
  depends_on "zstd" => :build
  depends_on "gtk+"
  depends_on "libticables"
  depends_on "libticalcs"
  depends_on "libticonv"
  depends_on "libtifiles"

  on_linux do
    depends_on "perl" => :build

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
      sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
    end
  end

  resource("testfile1") do
    url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/B38964FB6AF244DFA4674BA19128646C/CabriJr_CE.8ek"
    sha256 "6e28f09a50293a14c49ce438d2fa336392c538d44c4b5ef18964e239825d1303"
  end

  resource("testfile2") do
    url "https://education.ti.com/download/en/ed-tech/BCBFECEC5F4242B28E9AE89DA7C4BA59/19F6D328252E40C1BD528680D66B559D/TI84CEBundle-5.8.0.22.b84"
    sha256 "6ba1de2fc18bcc212059f18d9021da2d2d1e9b39795dff821e59f29a957b452b"
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
    resource("testfile1").stage testpath
    resource("testfile2").stage testpath
    shell_output("#{bin}/tilp --help")
    shell_output("#{bin}/tilp --version")
    system "#{bin}/tilp", "-n"
    system "#{bin}/tilp", "-n", "--cable", "Null", "--calc", "None", "CabriJr_CE.8ek", "TI84CEBundle-5.8.0.22.b84"
  end
end
