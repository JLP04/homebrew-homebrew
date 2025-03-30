class Libudfread < Formula
  desc "Library for reading UDF from raw devices and image files"
  homepage "https://code.videolan.org/videolan/libudfread/"
  url "https://code.videolan.org/videolan/libudfread/-/archive/dbb8d2c22e2f15f4f6c99c1904ff4e8d4c025b28/libudfread-dbb8d2c22e2f15f4f6c99c1904ff4e8d4c025b28.tar.gz"
  version "1.1.2"
  sha256 "4c806480fa16b082cdaa00aff016d0a9ae81861fb399360616c60ff7a5254ff1"
  license "LGPL-2.1-only"
  revision 1
  head "https://code.videolan.org/videolan/libudfread.git", branch: "master"
  livecheck do
    url :head
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any,                 arm64_sequoia: "df06b1f376f856b8db5f86fcf2a3e34e6e2b0a8e8b5e4c88579b96cdf8141520"
    sha256 cellar: :any,                 arm64_sonoma:  "243971efb65485cf6ab41bfce48f9f15e89290bd872b2a193912624c85ec4e86"
    sha256 cellar: :any,                 ventura:       "42a467d59087fde666c20d13582549fb54946999215a380868afed941df5672f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11bba0b7b6ed38763e8b54c5d61dc76fa78ae7b45dc2075c2988e1a1627bcca9"
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
