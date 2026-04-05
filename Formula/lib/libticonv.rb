class Libticonv < Formula
  desc "TiConv library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/5ab36f38fd1e38036c54201e272653a6d4ac970a.tar.gz"
  version "1.1.6"
  sha256 "c7e84716d46d6383ab03e39932368a4344ecf75a63570109409e264b08349587"
  license "GPL-2.0-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "360a04b1dee2694e50c5d5c5e015c30d7b3f32c1029498593b677e211e86ae1d"
    sha256 cellar: :any,                 arm64_sequoia: "309d2ef38f2294b046fb3b3601baab300c4bdbe995ce53afa68e971c82999e75"
    sha256 cellar: :any,                 arm64_sonoma:  "db8f6896412f7fe3e8290ebea55052f0bef660154a10c452fc195427f9c64b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15001f3c58aac5434d47b69fe68b848201cce626c7d51a4d7100c9072ca87020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da7ef54457ca6532ae9a9dd21254fef6e63731a07e6a7136496041989f6a46b"
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
