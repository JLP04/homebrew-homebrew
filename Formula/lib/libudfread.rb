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
    sha256 cellar: :any,                 arm64_sequoia: "693b8124dc6aa076c134641f07e0799a4a9c4ce3cdf3d3af3a858b7da4603690"
    sha256 cellar: :any,                 arm64_sonoma:  "2dcb814ce69beb3b2af5c1243eb2bc8ac43c76c22288735bdcd0459c95cc9910"
    sha256 cellar: :any,                 ventura:       "ed8282373cb9c02dc02a0c941eeac11005c6d9692775af816b00f1d997a3f3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32dc50777c50abb4b82b33c23d5f2fe832b7790a32f7979af62707952e1bc8d"
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
