class Libudfread < Formula
  desc "Library for reading UDF from raw devices and image files"
  homepage "https://code.videolan.org/videolan/libudfread/"
  url "https://code.videolan.org/videolan/libudfread/-/archive/a089d1bd4118f5072a1dbb76f459dc41bb106bb5/libudfread-a089d1bd4118f5072a1dbb76f459dc41bb106bb5.tar.gz"
  version "1.2.0"
  sha256 "756b4e7b2f10fce77928c0e2705d0b7d29a204b9fdf3b15673f806c623359413"
  license "LGPL-2.1-only"
  head "https://code.videolan.org/videolan/libudfread.git", branch: "master"
  livecheck do
    url :head
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b6ba6e965fccccb1ce1d9f657c8511c1f0fe9bb8cad338437f161c2cf2b23849"
    sha256 cellar: :any,                 arm64_sonoma:  "651dae059cda96875db82b1fc7f045a9f81eb562fe299468bc89140734f8e7f8"
    sha256 cellar: :any,                 ventura:       "79a4f79dc295eea826a3ce3188c811fe6db54dad32f55d9f0698a9c37d12aaf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7caecc878b5391efec7dbf90c9c64daa9ee5fb9275aa17e6e6460cd3b1175367"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :test

  def install
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <udfread/udfread.h>

      int main() {
        udfread *udf;

        udf = udfread_init();
        if (!udf) {
          fprintf(stderr, "udfread_init() failed\\n");
          return -1;
        }
        udfread_close(udf);
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libudfread").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
