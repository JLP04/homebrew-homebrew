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
    rebuild 2
    sha256 cellar: :any,                 monterey:     "986846dfafc2ae471f0eefcceb3ed43ce9f211f15238d16405309ad561026a33"
    sha256 cellar: :any,                 big_sur:      "e2b323614ab660d98cb52c04805d05b31e4ae7fae193f8ce83f71cc657b1b7a4"
    sha256 cellar: :any,                 catalina:     "0732ade58a7582485d18a5900b2c3e2e3e1f1d5b9b6bf7dc888a748bc74b6411"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5af19bd13516055a5a6f860b36cf7cc41675b230994334368fe5310aad5f74d0"
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
    system "make", "install"
  end

  test do
    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
  end
end
