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
    rebuild 10
    sha256 cellar: :any,                 arm64_tahoe:   "4e2e09b14ae52fa1399e3c0d2afbf77c893a0e80a467f5d5056be934f53e14e3"
    sha256 cellar: :any,                 arm64_sequoia: "a327e2c2260856d00c4408ba939350cc820559ee53037fbb8226cfb0ab4ca18d"
    sha256 cellar: :any,                 arm64_sonoma:  "5d84253b5b6ed78974494010f691ba27969471ce01a4c5b609f504d2c5c778ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16da3963974c945808ffec9f72d853450dc7c728290cc1ef62e6c599f626b8d8"
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
    Dir.chdir("#{testpath}/libs/libticables/trunk")
    system bin/"tfdocgen", "./"
    assert_path_exists testpath/"libs/libticables/trunk/docs/html/api.html"
  end
end
