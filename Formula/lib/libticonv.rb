class Libticonv < Formula
  desc "TiConv library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/5ab36f38fd1e38036c54201e272653a6d4ac970a.tar.gz"
  version "1.1.6"
  sha256 "c7e84716d46d6383ab03e39932368a4344ecf75a63570109409e264b08349587"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "6addb1f083aa28c119555eb266b8a117714ea41e984d335505a052ad050f4c2e"
    sha256 cellar: :any,                 ventura:      "53e4dfa7df2d2506e9e7eb45dffad5f664228d9265c4f5146071330f1a26bf96"
    sha256 cellar: :any,                 monterey:     "b3e8fc0828729e1ae3083faf8a1e0dcac38452f4bc3ed56d6fb95e4b85f9ecae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e28f70ab26d9cdee36714e3fe6b16bdf6132b8018d9b317437f3810f0e4446f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

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
