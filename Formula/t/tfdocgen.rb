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
    rebuild 9
    sha256 cellar: :any,                 arm64_sequoia: "729f2f7d962d4a0e5092c8c0da3b07e83965050f09a4cdad60f21b44a44439e5"
    sha256 cellar: :any,                 arm64_sonoma:  "5501f49064449ef7770a678070ff1acd7696aa35178df99ab03466d5ee2646bd"
    sha256 cellar: :any,                 ventura:       "2520ec809a9f679a1525ed7f5e92ec424a622997a654d6d00db7b31c96bace0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c883007a8efca260adb7c41cebb0de3a8c38f4814e1262133e362dc15ae58ce"
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
    assert_path_exists testpath/"libs/libticables/trunk/docs/html/api.html"
  end
end
