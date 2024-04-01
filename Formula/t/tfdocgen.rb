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
    rebuild 5
    sha256 cellar: :any,                 ventura:      "ab936873580610c9700f66e76646f450d71227b5ce870a63bd5467ceda6de09c"
    sha256 cellar: :any,                 monterey:     "32ec6c21a1afd011da2d7f6a2800986b42d79b02fb0ecc0ad6284e776b20f93e"
    sha256 cellar: :any,                 big_sur:      "d6cce478a467f5f3317c95cd45e0887b14a3bace471160a030d732a007bab5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1099dc4f149a9b7fbdd27ba14175aac978b3fa9baccf23042c192e27e37021b1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
    resource("testfile") do
      url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/B38964FB6AF244DFA4674BA19128646C/CabriJr_CE.8ek"
      sha256 "6e28f09a50293a14c49ce438d2fa336392c538d44c4b5ef18964e239825d1303"
    end

    shell_output("#{bin}/tfdocgen --version")
    shell_output("#{bin}/tfdocgen --help")
    resource("testdocs").stage testpath/"libs"
    Dir.chdir("#{testpath}/libs/libticables/trunk")
    system "#{bin}/tfdocgen", "./"
    assert_predicate testpath/"libs/libticables/trunk/docs/html/api.html", :exist?
  end
end
