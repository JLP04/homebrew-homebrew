class Libticonv < Formula
  desc "TiConv library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/12ff32e7bfd7652efae4b5d867bf231ab7d1b170.tar.gz"
  version "1.1.6"
  sha256 "720b07e811bcf2be8e6e5897e1d8501e7f3259bfa8b834af2cc1c7b6fbaeed69"
  license "GPL-2.0-or-later"
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any,                 monterey:     "a5f438421d79c2eb14390a407806ad1e25123c2dfa2858498ee095b8224a7c00"
    sha256 cellar: :any,                 big_sur:      "f190da9bf3b2142272564a38f145db7bb8b1600b1075afcd086f38a3fc16f8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a1e81b562cff983f4d142ce04f7fd7c998373d9d3ca4b07eff183ec20798758"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "tfdocgen" => :build
  depends_on "glib"

  def install
    Dir.chdir("libticonv/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <tilp2/ticonv.h>
      int main() {
        ticonv_version_get();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lticonv", "-o", "test"
    system "./test"
  end
end
