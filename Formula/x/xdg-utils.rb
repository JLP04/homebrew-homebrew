class XdgUtils < Formula
  desc "Tools allowing applications to easily integrate with the desktop environment"
  homepage "https://www.freedesktop.org/wiki/Software/xdg-utils/"
  url "https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/v1.2.1/xdg-utils-v1.2.1.tar.gz"
  sha256 "f6b648c064464c2636884c05746e80428110a576f8daacf46ef2e554dcfdae75"
  license "MIT"
  head "https://gitlab.freedesktop.org/xdg/xdg-utils.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "9ad5ab4a43571de5dfa3e8b5b2cb9fdcb06bb086f7810c5289ce2a64f5bfd465"
    sha256 cellar: :any_skip_relocation, ventura:      "b3cfc1224f401a909df6580d8b02f790469a02273553474ae518e4e5f93ccf46"
    sha256 cellar: :any_skip_relocation, monterey:     "39f350de5bf2ef6b2436ef09d5387d6d25dcd01262abf61973da696b081e2ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a91ed0ac27a48b879c39a8b05afc09da81676ec7aa9e098252fbf8ba61b2d9fe"
  end

  depends_on "lynx" => :build
  depends_on "xmlto" => :build

  on_linux do
    depends_on "lynx" => :test
    depends_on "mailutils" => :test
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    ENV["HOME"] = testpath
    ENV["BROWSER"] = "lynx" if OS.linux?
    ENV["MAILER"] = "mail" if OS.linux?
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
    assert_path_exists testpath/"Desktop/desktop_icon_install.desktop"
    system "#{bin}/xdg-desktop-icon", "uninstall", "desktop_icon_install.desktop"
    (testpath/"test.txt").write <<~EOS
      Hello.
    EOS
    system "#{bin}/xdg-open", testpath/"test.txt"
    system "#{bin}/xdg-open", "https://www.freedesktop.org/wiki/Software/xdg-utils/"
    (testpath/"test.html").write <<~EOS
      <html><body>Hello.</body></html>
    EOS
    system "#{bin}/xdg-open", testpath/"test.html"
    system "#{bin}/xdg-email", "'Jeremy White <jwhite@example.com>'" if OS.linux?
    system "#{bin}/xdg-mime", "query", "default", "text/plain"
    system "#{bin}/xdg-settings", "get", "default-web-browser" if OS.linux?
  end
end
