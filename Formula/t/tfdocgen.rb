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
    rebuild 15
    sha256 cellar: :any, arm64_golden_gate: "43c9467c907b43362a70022f41342a0ae754bfee4baef41f7d4a8f31bcb61658"
    sha256 cellar: :any, arm64_tahoe:       "a723f9d3b70b3dfb9e63e815f59f8273422ffeb95e9295e683c3c7696342e008"
    sha256 cellar: :any, arm64_sequoia:     "7c199a7444da4d23855d10a3d3ecc10ce80f4153b794417c91deed4751d3c6ea"
    sha256 cellar: :any, arm64_sonoma:      "b907672dd9a9856543b97f114e19b537817b9276698f8a6b5cab90cf8b542c86"
    sha256 cellar: :any, arm64_linux:       "391db5e29772ba487f79d7021b2f2826cf80303345efaa73c8de5430b1bebfd9"
    sha256 cellar: :any, x86_64_linux:      "f2dcebf95f1cf482f0ac800a0870e363434a28c29ff4388a35910d25afa0129d"
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

  # downloads test resources
  allow_network_access! :test

  def install
    Dir.chdir("trunk") if build.stable?
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    resource("testdocs") do
      url "https://github.com/debrouxl/tilibs/archive/6dba390e7390c4b98ae96287b39a3971c331fbef.tar.gz"
      sha256 "c6c37882b73e86d6bee6f9b253976479491ab4956fbf5e556e3a585c66c94a50"
    end

    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
    resource("testdocs").stage testpath/"libs"
    Dir.chdir(testpath/"libs/libticables/trunk")
    system bin/"tfdocgen", "./"
    assert_path_exists testpath/"libs/libticables/trunk/docs/html/api.html"
  end
end
