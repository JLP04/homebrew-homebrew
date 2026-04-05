class Tfdocgen < Formula
  desc "Documentation generator specific to https://github.com/debrouxl/tilibs"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tfdocgen/archive/a9d4bf89b9a54cdbddb970b3079d802a34d69cdb.tar.gz"
  version "1.00"
  sha256 "f760bf06c5b450508b6b3ff785cf58d4bdfbbf9d32f92cc152bb3998deb747f1"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/debrouxl/tfdocgen.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 12
    sha256 cellar: :any,                 arm64_tahoe:   "af6b95d5fc72080cb9e5074736a2bc9105ca822c3038279818e15b2b0892fbe8"
    sha256 cellar: :any,                 arm64_sequoia: "5e35387396e98d1bb06bb8a8d145f79f10a12db69d7bcf4406548496ebc8d781"
    sha256 cellar: :any,                 arm64_sonoma:  "9542bc72dbbbf315d681c4de61bcbf4995a8e3cc0fbc93ee6eccf5e2fb6c0298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d12634cd10675fecdcd4231a8adaf422dafdbee3adff9c2b5f70e21445f885c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3872684264e0e6f557e87561611ca36ca2b2317b820da38577019e9df5a78495"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2" => :build
  depends_on "pkgconf" => :build
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
      url "https://github.com/debrouxl/tilibs/archive/70aa26ba81ce8abdb1c6e081b2af1aa679bcc0f1.tar.gz"
      sha256 "2c4b1dba04f0c3de68c6ae90cba20ec641a13f60d6afd263ff3805c73dbb8993"
    end

    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
    resource("testdocs").stage testpath/"libs"
    Dir.chdir(testpath/"libs/libticables/trunk")
    system bin/"tfdocgen", "./"
    assert_path_exists testpath/"libs/libticables/trunk/docs/html/api.html"
  end
end
