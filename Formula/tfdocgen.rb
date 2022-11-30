class Tfdocgen < Formula
  desc "Documentation generator specific to https://github.com/debrouxl/tilibs"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tfdocgen/archive/a9d4bf89b9a54cdbddb970b3079d802a34d69cdb.tar.gz"
  version "1.00"
  sha256 "f760bf06c5b450508b6b3ff785cf58d4bdfbbf9d32f92cc152bb3998deb747f1"
  license "GPL-2.0-or-later"
  head "https://github.com/debrouxl/tfdocgen.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any,                 monterey:     "f626db68b00e514bcbad12fc3fe2746f5b7f3e0cf60f1c6ec64682795251d298"
    sha256 cellar: :any,                 big_sur:      "08d3593bd8b5871b1157538a65ed1474fa44179e33512663932a021be45abad0"
    sha256 cellar: :any,                 catalina:     "4aee181bbd8f58d6856ffd71af62d39cc20229ca34bd598cad86fcd77c258095"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b88f383c60cf4b72f5db8b1ae8ad21da50aea87b5e263e76e656dbbcfe0c556"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pcre2" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    Dir.chdir("trunk") if build.stable?
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
  end
end
