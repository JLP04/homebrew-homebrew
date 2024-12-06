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
    rebuild 8
    sha256 cellar: :any,                 arm64_sequoia: "d27f612dc23cf485809d8420edc58dcb5308233b0e615cd5562f2da2efca7580"
    sha256 cellar: :any,                 arm64_sonoma:  "586fa284ee0fe3e5d6285f70632c273822e61983139516e09984df75ec198849"
    sha256 cellar: :any,                 ventura:       "586af2987bc09d944f7f54258c60005943190b31083522a6a72eecac1f15c00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfd491839ac471afc710fb27a6451c075d63c67870e38ccc3ba4d79471b52e8"
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
