class Libtifiles < Formula
  desc "TiFiles library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/12ff32e7bfd7652efae4b5d867bf231ab7d1b170.tar.gz"
  version "1.1.8"
  sha256 "720b07e811bcf2be8e6e5897e1d8501e7f3259bfa8b834af2cc1c7b6fbaeed69"
  license "GPL-2.0-or-later"
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 monterey:     "dd08a99e23563fbd36f6b769334be4440c96c346d8ad20d5f88786059347c935"
    sha256 big_sur:      "f8d9423bcb9eaa122a20b9899fa05927eb4e2126392439747c4733395b386b76"
    sha256 x86_64_linux: "9459b4aeb29db846b90d52eb555ea9ba200b0a3f434af7f586d54b341a1c02be"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "libticonv"

  def install
    Dir.chdir("libtifiles/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <tilp2/tifiles.h>
      int main() {
        tifiles_library_init();
        tifiles_version_get();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags ticonv").chomp.split
    system ENV.cc, "test.c", *flags, "-L#{lib}", "-ltifiles2", "-o", "test"
    system "./test"
  end
end
