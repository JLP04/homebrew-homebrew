class Libglade < Formula
  desc "RAD tool to help build GTK+ interfaces"
  homepage "https://glade.gnome.org"
  url "https://download.gnome.org/sources/libglade/2.6/libglade-2.6.4.tar.gz"
  sha256 "c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3"
  license "GPL-2.0-only"
  compatibility_version 1

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 9
    sha256 arm64_golden_gate: "8984ee13f3a13030a4e6f884a070bd2310b76c89efa42be205587996473d9b75"
    sha256 arm64_tahoe:       "e6f6f43de5eca08d0ae4e39b9791e0a93e742378c3ce7b19c188eb0c692f5396"
    sha256 arm64_sequoia:     "c517d1277360b584434786abd7e9c8ea6716d2bdc9b4074498fe3e5dfd74b60a"
    sha256 arm64_linux:       "c28c670a0903b628fe4064d30f6fc847f8414b6d35a7a5d9ede49ea1a8703978"
    sha256 x86_64_linux:      "f0ce759b86130d5f1c9cfbc7079328dfa04507da4ef0987211b59b3a5a70f028"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "at-spi2-core"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  resource "config.guess" do
    url "https://git.savannah.gnu.org/cgit/config.git/plain/config.guess"
    version "2026-05-17"
    sha256 "ac18bbd7dc3769e1646af49ebba331a391829f4a73579b735dc8d439bd1c7f07"
    livecheck do
      url "https://git.savannah.gnu.org/cgit/config.git/plain/config.guess"
      regex(/timestamp='(.*)'/)
      strategy :page_match
    end
  end

  resource "config.sub" do
    url "https://git.savannah.gnu.org/cgit/config.git/plain/config.sub"
    version "2026-05-17"
    sha256 "f9a31e9a3f5b7cbeb8d8c3f2015895a51e7222130114c9c363fcbccd78e4bf6b"
    livecheck do
      url "https://git.savannah.gnu.org/cgit/config.git/plain/config.sub"
      regex(/timestamp='(.*)'/)
      strategy :page_match
    end
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-lgmodule-2.0"
    resource("config.guess").stage buildpath
    resource("config.sub").stage buildpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <glade/glade.h>

      int main(int argc, char *argv[]) {
        glade_init();
        return 0;
      }
    EOS
    ENV["PKG_CONFIG_PATH"] = "#{formula_opt_lib("libxml2")}/pkgconfig"
    flags_libxml2 = shell_output("pkg-config --cflags --libs libxml-2.0").chomp.split
    flags = %W[
      -I#{formula_opt_include("at-spi2-core")}/atk-1.0
      -I#{formula_opt_include("cairo")}/cairo
      -I#{formula_opt_include("fontconfig")}
      -I#{formula_opt_include("freetype")}/freetype2
      -I#{formula_opt_include("gdk-pixbuf")}/gdk-pixbuf-2.0
      -I#{formula_opt_include("gettext")}
      -I#{formula_opt_include("glib")}/glib-2.0
      -I#{formula_opt_lib("glib")}/glib-2.0/include
      -I#{formula_opt_include("gtk+")}/gtk-2.0
      -I#{formula_opt_lib("gtk+")}/gtk-2.0/include
      -I#{formula_opt_include("harfbuzz")}/harfbuzz
      -I#{include}/libglade-2.0
      -I#{formula_opt_include("libpng")}/libpng16
      -I#{formula_opt_include("pango")}/pango-1.0
      -I#{formula_opt_include("pixman")}/pixman-1
      -D_REENTRANT
      -L#{formula_opt_lib("at-spi2-core")}
      -L#{formula_opt_lib("cairo")}
      -L#{formula_opt_lib("gdk-pixbuf")}
      -L#{formula_opt_lib("gettext")}
      -L#{formula_opt_lib("glib")}
      -L#{formula_opt_lib("gtk+")}
      -L#{lib}
      -L#{formula_opt_lib("pango")}
      -latk-1.0
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglade-2.0
      -lglib-2.0
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    if OS.mac?
      flags << "-lgdk-quartz-2.0"
      flags << "-lgtk-quartz-2.0"
      flags << "-lintl"
    else
      flags << "-lgdk-x11-2.0"
      flags << "-lgtk-x11-2.0"
    end
    system ENV.cc, "test.c", "-o", "test", *flags, *flags_libxml2
    system "./test"
  end
end
