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
    sha256 cellar: :any_skip_relocation, ventura:      "77dba9a1113ef6d11fc42299c7f95f50b3fa9bbfcbb7ac4e4d9b6dd99ab7c63e"
    sha256 cellar: :any_skip_relocation, monterey:     "c72081994cdea2f3ce10b69e0d967e0e0bb49cbecc6d69945cb3661c927c1343"
    sha256 cellar: :any_skip_relocation, big_sur:      "23ada88cd605dddade892d7ed102d3a7308859317c242ad62c362d6e3a505c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "610649d24ef49aac6071e00d3fdb648f3e3e087c33de54bd396b9b4aebbac09f"
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
