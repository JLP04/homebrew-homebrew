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
    sha256 cellar: :any, arm64_tahoe:   "7b2e8cff7f0ec53a0242351f73712a68a69541d0b3df55129e720a5294a8441e"
    sha256 cellar: :any, arm64_sequoia: "eb8371a93685f818c7ab1aaaf5a724ca55ca149678aff291bbcdac3b4eedc863"
    sha256 cellar: :any, arm64_sonoma:  "868220490b6974e0f93254b563453c3fc8e2b183654f38c7a6abdbd155be32d2"
    sha256 cellar: :any, arm64_linux:   "88ba78695e41647318ff6b6aa821d48065dd20a0d0ebf127fd2d3db2f64c2a59"
    sha256 cellar: :any, x86_64_linux:  "0767c544dadedfca7c3abc66e66e494c5f81eaaa6189c000eec8475c766b12d1"
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
