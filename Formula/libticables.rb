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
    sha256 monterey:     "b716089297721c149184a9667eda429eff1788d5cd3c305602ff27526b1a8fd4"
    sha256 big_sur:      "ce89ed919335d11d97c7bb8e2edc80cf25e3b41d054368c9e119b99731dd2028"
    sha256 x86_64_linux: "5c800e092e425cfc4f9077c336d9c631858a35b72c4d3bad8b72322511800e2a"
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
