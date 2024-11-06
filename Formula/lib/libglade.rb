class Libglade < Formula
  desc "RAD tool to help build GTK+ interfaces"
  homepage "https://glade.gnome.org"
  url "https://download.gnome.org/sources/libglade/2.6/libglade-2.6.4.tar.gz"
  sha256 "c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 arm64_sonoma: "c399d19099304378a33a0218d5f1d65ea1dc22d11ad85152a07aa3c180ae12e0"
    sha256 ventura:      "9c492d18483c8bd2b6c114359686f9a09fff6e8fe3bd670dd3ac35689d279211"
    sha256 monterey:     "ad5a6cbc2dd9d93ed46db69bd5f86b119c11a7658b2d81d1362b18b8a4e908aa"
    sha256 x86_64_linux: "61198ad9be7410cf961b742c2ac8ab30e03dc263ba3d356d1f5ee838a5732408"
  end

  depends_on "pkg-config" => :build
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

  def install
    ENV.append "LDFLAGS", "-lgmodule-2.0"
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
    ENV.libxml2
    atk = Formula["at-spi2-core"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libglade-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
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
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
