class Libticables < Formula
  desc "TiCables library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/12ff32e7bfd7652efae4b5d867bf231ab7d1b170.tar.gz"
  version "1.3.6"
  sha256 "720b07e811bcf2be8e6e5897e1d8501e7f3259bfa8b834af2cc1c7b6fbaeed69"
  license "GPL-2.0-or-later"
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 monterey:     "7d9272ec1358e37df1895540f1b058cd2f2be7bdd1dd908b89f1def000dd88b9"
    sha256 big_sur:      "337832b79c0a6298b098a7ee29ff759d71b5dafd49e4fc87db035296cd7b533c"
    sha256 x86_64_linux: "64941bb3497a0aa0c6a14f28c8f4548e9c6c04e6e297567a564bec7a14d3820d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libusb"

  def install
    Dir.chdir("libticables/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-libusb10"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tilp2/ticables.h>
      int main() {
        ticables_library_init();
        ticables_library_exit();
        ticables_version_get();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lticables2", "-o", "test"
    system "./test"
  end
end
