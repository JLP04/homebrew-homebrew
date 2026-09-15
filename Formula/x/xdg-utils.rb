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
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3872361bbb1005963c65e2cf45a76698110b6126645ee8b0b1299269f7066ca1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e22690c905fc47e224186e6928e40dd5d167893c7b9c532e82b0ec337464ef59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cacf94f9eb3b6e7a546374b2c028b406e858ae868614083b4a5db26236da69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "46c3410a2b360685c089d6cfc88fc4570125d388179f58d3fcb117ab80b68e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6fe4532524b97071ad55e369cd3cdee2f9dd3f52bc7b7afc60d3d7ffaa32c563"
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
    if OS.linux?
      (testpath/"test.txt").write <<~EOS
        Hello.
      EOS
      system "#{bin}/xdg-open", testpath/"test.txt"
      system "#{bin}/xdg-open", "https://www.freedesktop.org/wiki/Software/xdg-utils/"
      (testpath/"test.html").write <<~EOS
        <html><body>Hello.</body></html>
      EOS
      system "#{bin}/xdg-open", testpath/"test.html"
    end
    system "#{bin}/xdg-email", "'Jeremy White <jwhite@example.com>'" if OS.linux?
    system "#{bin}/xdg-mime", "query", "default", "text/plain"
    system "#{bin}/xdg-settings", "get", "default-web-browser" if OS.linux?
  end
end
