class Clamtk < Formula
  desc "Easy to use, light-weight, on-demand virus scanner for Linux systems"
  homepage "https://gitlab.com/dave_m/clamtk/-/wikis/home"
  url "https://gitlab.com/dave_m/clamtk/-/archive/662124a88f9a3ce789f48ea4704d059922a207dd/clamtk-662124a88f9a3ce789f48ea4704d059922a207dd.tar.gz"
  version "6.16"
  sha256 "4c5b80c127c54b306135c6365d715c5a64c36f28c67a21b55eb70854e41217ab"
  license all_of: [
    "BSD-3-Clause",
    any_of: ["GPL-1.0-or-later", "Artistic-2.0"],
  ]
  head "https://gitlab.com/dave_m/clamtk.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 cellar: :any_skip_relocation, monterey:     "db74bcca301aae867bc7113579058061847bb8d4e93a676b5d0f54e210c3f2ab"
    sha256 cellar: :any_skip_relocation, big_sur:      "8e5a28b8f0ad2c2a0c039e5d2c3bb941776d62d1ed21daba1088deecafb0c7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abe7b9fdb893fa39e501313ed49a36c031b0e3041933b68ee3ffd83bd6952303"
  end
  option "with-perlbrew", "Install using perlbrew's perl"

  depends_on "clamav"
  depends_on "perl"

  def install
    inreplace "lib/App.pm" do |s|
      s.gsub! "/usr/share/pixmaps", HOMEBREW_PREFIX/"share/pixmaps"
      s.gsub! "/.local/share/Trash", "/.Trash" if OS.mac?
    end
    bin.install "clamtk"
    man1.install "clamtk.1.gz"
    mkdir "#{share}/applications"
    mkdir "#{share}/metainfo"
    mkdir "#{share}/perl5/vendor_perl/ClamTk"
    mkdir "#{share}/pixmaps"
    (share/"applications").install "clamtk.desktop"
    (share/"metainfo").install "com.github.davetheunsub.clamtk.appdata.xml"
    (share/"perl5/vendor_perl/ClamTk").install Dir["lib/*.pm"]
    (share/"pixmaps").install Dir["images/*"]
  end

  def post_install
    if build.with? "perlbrew"
      inreplace "#{bin}/clamtk", "#!#{HOMEBREW_PREFIX}/opt/perl/bin/perl", "#!/usr/bin/env perl"
    end
  end

  def caveats
    if build.with? "perlbrew"
      <<~EOS
        If you want to install ClamTk to a perlbrew perl, run the following:
        for d in /opt/perl5/perls/perl-*; do
          sudo mkdir -p "$d"/lib/site_perl/5.*/ClamTk
        done
        sudo cp /usr/local/share/perl5/vendor_perl/ClamTk/*.pm /opt/perl5/perls/perl-*/lib/site_perl/5.*/ClamTk/
      EOS
    end
  end

  test do
    system "which", "clamtk"
  end
end
