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
    sha256 cellar: :any_skip_relocation, ventura:      "e087a56b7fd1aac99244459bb5a1964b2750ccb37c7ee8e9b813e7e7d733d991"
    sha256 cellar: :any_skip_relocation, monterey:     "fe3f5c4de3cce3806b6d474532b224abc78a2f77fe4e5696add84fd5173b28df"
    sha256 cellar: :any_skip_relocation, big_sur:      "6bc2021b963728f79b2f478c5002b498dc81bb5d5c4d13178b6b4bd11858e714"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "668fdc454fa74916188e5ebefc5a8d4da96fd85e5832036045fa1abe1bad9166"
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
    assert_predicate testpath/"Desktop/desktop_icon_install.desktop", :exist?
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
