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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0dd91a2de29645d227214afca0c0224b1ec2b3cb831a056ac2bfa2ea9a687b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53ad983cea5ecb32cffa808f02475f4a956d4780c50202dcbbcdd518eaaff9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724ecbb3b1630d0e0f5d5753b7989aa9ee4dc4fcb646503d9e8aa4a6f5b00ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d95ef70d9199c6e42567e4e6b4dc30c384d636cf61c3f24d27189cacc8aadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a9e6bac325601f61325053a7088a207a5da33c3685ac16eac6cc760b2840bff"
  end

  depends_on "w3m" => :build
  depends_on "xmlto" => :build

  on_linux do
    depends_on "w3m" => :test
  end

  deny_network_access!

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    ENV["HOME"] = testpath
    ENV["BROWSER"] = "w3m" if OS.linux?
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
