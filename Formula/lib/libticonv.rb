class Libticonv < Formula
  desc "TiConv library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/76b3c8f218d4c6a580338c73d32b7b57c883a562.tar.gz"
  version "1.1.6"
  sha256 "82c9b536e48efe1148ca34d1a3469dd8c59e9afd20db4aae15855f065ad46217"
  license "GPL-2.0-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    url "https://raw.githubusercontent.com/debrouxl/tilibs/refs/heads/master/libticonv/trunk/configure.ac"
    regex(/VERSION="(.*)"/i)
    strategy :page_match
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "c3cc77284904a8d22a3baeb65bdbabdb741c66d3853a04dce361f4ce88f2fc38"
    sha256 cellar: :any, arm64_tahoe:       "11bc56d5aa2e8ca5bf85d5f0aaedbed93e8e9cdca5fd8ef7167db0ee85e9ba76"
    sha256 cellar: :any, arm64_sequoia:     "aed1ab60e5330cd4bbd706268b02ab8e1c7bc08d1d9bde596591c5d73540fb23"
    sha256 cellar: :any, arm64_linux:       "ca2ccd30cb32f9c2bc790bf96283c6a373747c45ced0487c50998e6dc077a3ea"
    sha256 cellar: :any, x86_64_linux:      "f2d3c170f890e0704553d4347b86bc9047c83b1f6350b1317a12a44e7b6364f4"
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

  deny_network_access!

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
