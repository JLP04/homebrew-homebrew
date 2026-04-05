class XdgUtils < Formula
  desc "Tools allowing applications to easily integrate with the desktop environment"
  homepage "https://www.freedesktop.org/wiki/Software/xdg-utils/"
  url "https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/v1.2.1/xdg-utils-v1.2.1.tar.gz"
  sha256 "f6b648c064464c2636884c05746e80428110a576f8daacf46ef2e554dcfdae75"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.freedesktop.org/xdg/xdg-utils.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbee5b28833b0a259eed92ac74460a87b84412f1299cc6cc77a9956dff9630d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a057ffa01ce04f6f25232b7c78847cc0eb98bd618d7f51469d29dbc645c48df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1b06037cd43f079e420867e83f7968a154fa7e25badf8050f91f10e8db92d10"
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
