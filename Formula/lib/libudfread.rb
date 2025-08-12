class Libudfread < Formula
  desc "Library for reading UDF from raw devices and image files"
  homepage "https://code.videolan.org/videolan/libudfread/"
  url "https://code.videolan.org/videolan/libudfread/-/archive/c3cd5cbb097924557ea4d9da1ff76a74620c51a8/libudfread-c3cd5cbb097924557ea4d9da1ff76a74620c51a8.tar.gz"
  version "1.2.0"
  sha256 "cad9c997dda97a5bc9e0e01a664fd8ac9deb227bca09124f87666ed1e4d4dba6"
  license "LGPL-2.1-only"
  revision 1
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

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
