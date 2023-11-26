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
    sha256 cellar: :any,                 ventura:      "d05774049fa6d850d8594f3b42be191c5343d7a1e998cdf950743f3f7a0631a7"
    sha256 cellar: :any,                 monterey:     "c5d86e51d8708e3e307900f83e5a4a7f4ed1a69c698a89083f13a6f3122fba30"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc7442aa40967e1758c0f53ebfc071099b2ab888cec85be454c2b1af283d3c7f"
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
