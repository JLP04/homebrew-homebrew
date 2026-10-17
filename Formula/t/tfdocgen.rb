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
    rebuild 16
    sha256 cellar: :any, arm64_golden_gate: "4e18232e995b278b8052218318c8a2d7009b6a055e7b3dabb42243abc841e329"
    sha256 cellar: :any, arm64_tahoe:       "7d298804c7f00bedbd76df07c139c69d10e7d6d9ea27e36a05f92915e2014f48"
    sha256 cellar: :any, arm64_sequoia:     "2f8d79a4c03a793e75688e533e5a73cb91840a783123748f87db51e6b1b6f963"
    sha256 cellar: :any, arm64_linux:       "e51b4f817132fc4cf5deb2b4f385e7fe3f0beb9bc9e23204b0a31ed94b9b09f7"
    sha256 cellar: :any, x86_64_linux:      "808a7a612f558f26f0a88d381194ea07ce7de531d6bb5d015dc0b2799650b4a9"
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

  resource "testdocs", :test do
    url "https://github.com/debrouxl/tilibs/archive/6dba390e7390c4b98ae96287b39a3971c331fbef.tar.gz"
    sha256 "c6c37882b73e86d6bee6f9b253976479491ab4956fbf5e556e3a585c66c94a50"
  end

  deny_network_access!

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
    Dir.chdir(testpath/"libs/libticables/trunk")
    system bin/"tfdocgen", "./"
    assert_path_exists testpath/"libs/libticables/trunk/docs/html/api.html"
  end
end
