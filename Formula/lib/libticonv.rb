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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "a083edaca59851945965b50a3a2b6571a0f073ca6da0654132b3f42d22050603"
    sha256 cellar: :any,                 arm64_sonoma:  "6d2d5b270282e6cac602c4921a9caa626e123407c2babc49703373d0307e9604"
    sha256 cellar: :any,                 ventura:       "5dc48dd6adee5001604f4475539f5c9bce26258dbeb44ac08846386651bfaef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb899987e036896932a91b2155f0095463ff428e7c1adf89b0b17380b1104ca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
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
