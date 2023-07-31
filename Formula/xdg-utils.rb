class XdgUtils < Formula
  desc "Tools allowing applications to easily integrate with the desktop environment"
  homepage "https://www.freedesktop.org/wiki/Software/xdg-utils/"
  url "https://portland.freedesktop.org/download/xdg-utils-1.1.3.tar.gz"
  sha256 "d798b08af8a8e2063ddde6c9fa3398ca81484f27dec642c5627ffcaa0d4051d9"
  license "MIT"
  head "https://gitlab.freedesktop.org/xdg/xdg-utils.git", branch: "master"
  livecheck do
    url "http://portland.freedesktop.org/download/"
    regex(/href=.*?xdg-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "lynx" => :build
  depends_on "xmlto" => :build

  on_linux do
    depends_on "w3m" => :test
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    ENV["HOME"] = testpath
    (testpath/"desktop_icon_install.desktop").write <<~EOS
      [Desktop Entry]
      Version=1.0
      Encoding=UTF-8
      Type=Application

      Exec=touch xdg-test-desktop-icon-install.tmp

      Name=Desktop_Icon
      StartupNotify=false
    EOS
    system "#{bin}/xdg-desktop-icon", "install", "--novendor", "desktop_icon_install.desktop"
    assert_predicate testpath/"Desktop/desktop_icon_install.desktop", :exist?
    system "#{bin}/xdg-desktop-icon", "uninstall", "desktop_icon_install.desktop"
    (testpath/"test.txt").write <<~EOS
      Hello.
    EOS
    system "#{bin}/xdg-open", testpath/"test.txt"
    system "#{bin}/xdg-open", "http://portland.freedesktop.org/wiki/"
    (testpath/"test.html").write <<~EOS
      <html><body>Hello.</body></html>
    EOS
    system "#{bin}/xdg-open", testpath/"test.html"
    system "#{bin}/xdg-email", "'Jeremy White <jwhite@example.com>'" if OS.linux?
  end
end
