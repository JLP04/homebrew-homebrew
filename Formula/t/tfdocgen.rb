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
    rebuild 13
    sha256 cellar: :any, arm64_tahoe:   "6ea3d201070ed8dec8f3e9a5aadc250954f9e69b7f9636c158546af440585d46"
    sha256 cellar: :any, arm64_sequoia: "8175a9820cc2882c1dcd6e52b7c66b7a88a42c2cae4ec6dc15e556704857796d"
    sha256 cellar: :any, arm64_sonoma:  "d813db60f85af32cedd37430c2303170be4cacbb8a227dd7a2db0fd9e4acdbcb"
    sha256 cellar: :any, arm64_linux:   "93739d444af1351a18a084d13d075a225575532791959131437338cca4edcf4d"
    sha256 cellar: :any, x86_64_linux:  "f772139f24e218a453530e1fcfbfadc04513d14c48a6cb427f20476cc8ec0f23"
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
