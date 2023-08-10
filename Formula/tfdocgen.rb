class Tfdocgen < Formula
  desc "Documentation generator specific to https://github.com/debrouxl/tilibs"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tfdocgen/archive/a9d4bf89b9a54cdbddb970b3079d802a34d69cdb.tar.gz"
  version "1.00"
  sha256 "f760bf06c5b450508b6b3ff785cf58d4bdfbbf9d32f92cc152bb3998deb747f1"
  license "GPL-2.0-or-later"
  head "https://github.com/debrouxl/tfdocgen.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 4
    sha256 cellar: :any,                 ventura:      "05de5e494b6574503515d140b2c507917a700ab7da4bf99a05bbfa995059a2c3"
    sha256 cellar: :any,                 monterey:     "a9e4d15a2d381c184ef9d45317fae31c07048e5427ac7dcfbb76c6f246056068"
    sha256 cellar: :any,                 big_sur:      "78693734752015623e0a99a01974599366f2645d9f8b55ffe3d61e17f7228f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "399f4ee878e098ce2e73998cccf28f7bf508caa02a4884f69f52d4777c30e84c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  resource "testdocs" do
    url "https://github.com/debrouxl/tilibs/archive/27586cc02a07777836a7974f020bdfdb43789b83.tar.gz"
    sha256 "85e6e9c716d4247ae8e0eb6813738a131cb92cf938fc56078979e1030f05ab08"
  end

  def install
    Dir.chdir("trunk") if build.stable?
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
    resource("testdocs").stage testpath/"libs"
    Dir.chdir("#{testpath}/libs/libticables/trunk")
    system "#{bin}/tfdocgen", "./"
    assert_predicate testpath/"libs/libticables/trunk/docs/html/api.html", :exist?
  end
end
