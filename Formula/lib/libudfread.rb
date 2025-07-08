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
    sha256 cellar: :any,                 arm64_sequoia: "2503af3f963044f09e4363eedf3604f5553a9347ef2977fc968a2865f6d65995"
    sha256 cellar: :any,                 arm64_sonoma:  "252d7b0db25617c089e80d1025fc3b94c1eddb4d606a0bc10ba4308f9a54378d"
    sha256 cellar: :any,                 ventura:       "5a2e1283fd291f2bfa27dc6f0f9328fdb791a4fa1309d35b1532403e7c7b5b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec6d611c0f8d13ebffef190c52cf3a9ea59cc9003824ce7c8b9b22a26a15900"
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
