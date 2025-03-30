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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "791bca0fb7454415b4963ad05ed2a5b1be87f2476f99c2dc1af87326ee30a658"
    sha256 cellar: :any,                 arm64_sonoma:  "91bffc33858c81b285700094a9579fa510b2ab60fb3e19fb36e2afc9353d4366"
    sha256 cellar: :any,                 ventura:       "c476e0108996ef5377444d43f8b45155715143fb20cea7bcaae8769d8e248c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c1d664be336c9de5a042259d5c995070a5b4a60fa89b0569a988d3cab03938"
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
