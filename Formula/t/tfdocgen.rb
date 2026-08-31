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
    rebuild 14
    sha256 cellar: :any, arm64_tahoe:   "4b7fd8f75c53dfff2668ec380fb3464230166a8436b206380ee69930eba6b47a"
    sha256 cellar: :any, arm64_sequoia: "311adda27543249e9dea208edc7f92fabbf3800c79b54109c8915f2cf81791cf"
    sha256 cellar: :any, arm64_sonoma:  "9d07f97798dcbcad0b410aadd8890c71697e6b61a41133784b46f92dbc30c118"
    sha256 cellar: :any, arm64_linux:   "d223f51d06b6cef895d7d4bf409c46ee15970d425574bdf6623626449dfd5c4e"
    sha256 cellar: :any, x86_64_linux:  "c04d775f1a12460edee3bd4954c2f0110e33c5c8d6c3854d9e8cf39f8f5cee71"
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
      url "https://github.com/debrouxl/tilibs/archive/6b05504e663b7310f77f876ef4286f504091860f.tar.gz"
      sha256 "d936b4adfb24f6e300d87c9999d01772cc20f2718077e8040923849c0e15dcf3"
    end

    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
    resource("testdocs").stage testpath/"libs"
    Dir.chdir(testpath/"libs/libticables/trunk")
    system bin/"tfdocgen", "./"
    assert_path_exists testpath/"libs/libticables/trunk/docs/html/api.html"
  end
end
