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
    rebuild 4
    sha256 cellar: :any, arm64_tahoe:   "6b0c71620db0372469e13ac614f7232ed9acc8c6d3a83d4da44686e200a18d0f"
    sha256 cellar: :any, arm64_sequoia: "30bfe635c468a57777abe02fbf651212f7cbc98eeb3409f3e0ce242238ee4bb7"
    sha256 cellar: :any, arm64_sonoma:  "1d6718a34740199b98a2fb4fdd371f34c4b62309db478d103c59308634457976"
    sha256 cellar: :any, arm64_linux:   "c4c8a966b130f0c2340ba81d466ab980951d1da9cd87262dcd6e6a7f4a27a24e"
    sha256 cellar: :any, x86_64_linux:  "5399aee3f73b37917fb75acde17eb1c15aa84cf0772f04fd665369838c139e6f"
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
