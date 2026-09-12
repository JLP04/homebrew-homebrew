class Libtifiles < Formula
  desc "TiFiles library is a part of the TiLP project"
  homepage "http://lpg.ticalc.org/prj_tilp"
  url "https://github.com/debrouxl/tilibs/archive/6dba390e7390c4b98ae96287b39a3971c331fbef.tar.gz"
  version "1.1.8"
  sha256 "c6c37882b73e86d6bee6f9b253976479491ab4956fbf5e556e3a585c66c94a50"
  license "GPL-2.0-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/debrouxl/tilibs.git", branch: "master"
  livecheck do
    skip "Based on git commits, version number doesn't change"
  end
 
  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 arm64_tahoe:   "5957587744cd076fdeca7446f03c003836863bf82d1991cbff55dca841e2d1ee"
    sha256 arm64_sequoia: "211a27cadfdb158dfa300c9d17572c323baab98379883b72d8e63334551d77b1"
    sha256 arm64_sonoma:  "32e005bcd88255ecd297c98144766699e6fdc9ba2a102930e985b314e83264e5"
    sha256 arm64_linux:   "1d45b877ff6f91093a97b8dcab499e1d3204b92eb4c03afaa04e707274bc4d9a"
    sha256 x86_64_linux:  "69695c0912cc4032c946a4301993dba2570dca68f5c8c465cc0e8e5f5c87f30b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "tfdocgen" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "libticonv"

  on_macos do
    depends_on "gettext"
  end

  # downloads test resources
  allow_network_access! :test

  def install
    Dir.chdir("libtifiles/trunk")
    system "autoreconf", "-i", "-f"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("testfile") do
      url "https://education.ti.com/download/en/ed-tech/55EDE969CFD2484487B4556641BDDC4E/99F094C3FF7140A998994A8BE767A2E0/CabriJr_CE_5.8.3.0048.8ek"
      sha256 "845594b672bd20f0903caa6ea93295601e802a901be3f2efdc480a3607d0eba8"
    end

    (testpath/"test.c").write <<~EOS
      #include <tilp2/tifiles.h>

      int main() {
        FlashContent *content;

        content = tifiles_content_create_flash(CALC_TI84PCE_USB);

        tifiles_library_init();
        tifiles_version_get();

        tifiles_file_read_flash("CabriJr_CE_5.8.3.0048.8ek", content);
        tifiles_file_display_flash(content);

        return 0;
      }
    EOS
    resource("testfile").stage testpath
    ENV["PKG_CONFIG_PATH"] = "#{formula_opt_lib("libarchive")}/pkgconfig"
    flags = shell_output("pkg-config --cflags --libs tifiles2").chomp.split
    system ENV.cc, "-Os", "-g", "-Wall", "-W", "test.c", *flags, "-o", "test"
    system "./test"
  end
end
