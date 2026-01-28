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
    rebuild 11
    sha256 cellar: :any,                 arm64_tahoe:   "bb5fca46a58926f6c1e09a76d3214def98842d9146c57ce803576d9281b9098b"
    sha256 cellar: :any,                 arm64_sequoia: "76b0ca6cb7028b0578b3d6e1ea599178518e23d657884f2b6a296b68a63b7e5d"
    sha256 cellar: :any,                 arm64_sonoma:  "1d264931ba3c7064ee3b694f0317ac8250c6bcfe93c5ce5c6b948af56b03532f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1816d1cf0baed51929fe77290a2ddb1e75148bdec462353504002424952178c8"
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
