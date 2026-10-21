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
    url "https://raw.githubusercontent.com/debrouxl/tfdocgen/refs/heads/master/trunk/configure.ac"
    regex(/AC_INIT\(tfdocgen, (.*), \[tilp-users@lists\.sourceforge\.net\]\)/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 17
    sha256 cellar: :any, arm64_golden_gate: "e5d8f3f2eac0714d3b42c045fd14ffb6d53e92622fac8dc254af436420937b97"
    sha256 cellar: :any, arm64_tahoe:       "34e750e2dbf6209e70ab9f048d17ee614422495c22c2d325fc58b6ad6d4d2b10"
    sha256 cellar: :any, arm64_sequoia:     "98e86e8d049b0e2cbda069c1347e959a1560c55455ec4c102b386e957e8fbe89"
    sha256 cellar: :any, arm64_linux:       "7df83e2b1dc584114a42ea3fd138244ad1bd8c1a70dccdb05434aaf5a382ae16"
    sha256 cellar: :any, x86_64_linux:      "aa01da3fee10409c1b998bd6f5fbe9e5a092a1dc140075851311c0ff13d8ccc7"
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
