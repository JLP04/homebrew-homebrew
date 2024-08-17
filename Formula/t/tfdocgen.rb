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
    rebuild 6
    sha256 cellar: :any,                 arm64_sonoma: "44cfc33b4e7b089e8efa9a220633d6cdd4e88209f98e7590526aaab73b314c9a"
    sha256 cellar: :any,                 ventura:      "5445fdec113d872684b65950fa9606de31422d63a3202a7176e02f6f434be383"
    sha256 cellar: :any,                 monterey:     "2fd5bd1e9fa3a1bb031a51706e54dde5b27763a4a847abd3c48b4d5047e5721a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c217acee5ca97f2bccaa28573d0e96fb67ed45a7f74d98b1402d9981b1170ea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    Dir.chdir("trunk") if build.stable?
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    resource("testdocs") do
      url "https://github.com/debrouxl/tilibs/archive/7c4858d85ba65b693df171ccbf31ed04e0b06b8e.tar.gz"
      sha256 "e1ea7f18ff3668dd40bd3919d74791fb7f6b4123d0c4a30063ae47bc49cd89c9"
    end

    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
    resource("testdocs").stage testpath/"libs"
    Dir.chdir("#{testpath}/libs/libticables/trunk")
    system bin/"tfdocgen", "./"
    assert_predicate testpath/"libs/libticables/trunk/docs/html/api.html", :exist?
  end
end
