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
    skip "Based on git commits, version number doesn't change"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "07b83ba6e408f16b776b6964edf7df62233bf94075d256bbfd17888a03cb4b37"
    sha256 cellar: :any, arm64_tahoe:       "c8eb67c7d754c9eccb1c77a00a51d7ce67ed1cdfca90fd27e8c0d07b1964015a"
    sha256 cellar: :any, arm64_sequoia:     "fb3e5c40976bcd0166953592e644d3310e97fab53034fed1e02415c1a71b3a40"
    sha256 cellar: :any, arm64_linux:       "451d20253eb62b101d83d43f2007d0021797b15fe39816155074a8764bc9ce17"
    sha256 cellar: :any, x86_64_linux:      "bc5411a1e8681187546e4eb05f297797b2575e9f4ca2bcb0a7a77cfa68e850d6"
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
