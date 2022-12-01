class Tfdocgen < Formula
  desc "Documentation generator specific to https://github.com/debrouxl/tilibs"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tfdocgen/archive/a9d4bf89b9a54cdbddb970b3079d802a34d69cdb.tar.gz"
  version "1.00"
  sha256 "f760bf06c5b450508b6b3ff785cf58d4bdfbbf9d32f92cc152bb3998deb747f1"
  license "GPL-2.0-or-later"
  head "https://github.com/debrouxl/tfdocgen.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 cellar: :any,                 monterey:     "24f5ecb9fd9bb7bace99dc04be7c7ac03f9fda534b7d8fc5448dcb06d965cd03"
    sha256 cellar: :any,                 big_sur:      "1b0deb06d3d02d99a765e49aa0bab239b51dfd4909690969181e8fac0c00d899"
    sha256 cellar: :any,                 catalina:     "2a5ceaef59aab362e281d2a7629359f43bce1b07e4212644d0bfedb9c6f7f172"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d52ca91d376211fd40aadf14b71a6e7dfb5445f7aa0aba008887acaf5b6bdb0b"
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
