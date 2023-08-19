class Libticonv < Formula
  desc "TiConv library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/d4ba6ea0fbbf0024c36015d5e026231944785c58.tar.gz"
  version "1.1.6"
  sha256 "e287864fc88dc3b41a89c8013ae99de38afa6c8756f2ed9fc6d7875c7a8d12b0"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 2
    sha256 cellar: :any,                 monterey:     "d641e87c50c10ca6cacd4e7a984b7a5746e1846f839951515fae23e6b8564bbf"
    sha256 cellar: :any,                 big_sur:      "8001596fd33406344fd0283bda7b66bc2a05e7a9e4c498aa188ce672b34dabdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca028e7130182ee19bd567a1fe64e16a60631adad6a5f06552deb60bd5b411e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"

  def install
    Dir.chdir("libticonv/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <glib.h>
      #include <ticonv.h>

      int main() {
        ticonv_version_get();
        char ti92_varname[9] = { 0 };
        char *utf8;

        utf8 = ticonv_varname_to_utf8(CALC_TI92, ti92_varname, -1);
        printf("UTF-8 varname: <%s> (%i)\\n", ti92_varname, (int)strlen(ti92_varname));
        ticonv_utf8_free(utf8);
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs ticonv").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
