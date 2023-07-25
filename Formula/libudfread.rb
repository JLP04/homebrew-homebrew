class Libudfread < Formula
  desc "Library for reading UDF from raw devices and image files"
  homepage "https://code.videolan.org/videolan/libudfread/"
  url "https://code.videolan.org/videolan/libudfread/-/archive/b3e6936a23f8af30a0be63d88f4695bdc0ea26e1/libudfread-b3e6936a23f8af30a0be63d88f4695bdc0ea26e1.tar.gz"
  version "1.1.2"
  sha256 "990c672d52d49af5513d7950a71b6b16791d1111dcfaabcde82e4ff3c7715999"
  license "LGPL-2.1-only"
  head "https://code.videolan.org/videolan/libudfread.git", branch: "master"
  livecheck do
    url :head
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any,                 ventura:      "8f9a15e09cfa31d2fa18fd1abb864793e724b0fadb79d4d9c1ec4188e10cd3e1"
    sha256 cellar: :any,                 monterey:     "628d4f0c7c656cc03712c7428ea9af0375b79a269c99bda5ff5694c5fe9c07c0"
    sha256 cellar: :any,                 big_sur:      "887e4360a8ced30899ed26f4c6bfa5653dadf457d90d34535107cb84fa103353"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b9df39b0487f8ced9f240b730ab4690c5f894f52b5ef81552a6f084bc31d68b6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :test

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
