class Clamtk < Formula
  desc "Easy to use, light-weight, on-demand virus scanner for Linux systems"
  homepage "https://gitlab.com/dave_m/clamtk/-/wikis/home"
  url "https://gitlab.com/dave_m/clamtk/-/archive/0d118b5d7cf0125dfed3e1e54a548970a2270abe/clamtk-0d118b5d7cf0125dfed3e1e54a548970a2270abe.tar.gz"
  version "6.15"
  sha256 "44b9ae91c76ae40924b56c9d9275382c6bd8afdd3c7bc03a2a2decb2d7d8c533"
  license all_of: [
    "BSD-3-Clause",
    any_of: ["GPL-1.0-or-later", "Artistic-2.0"],
  ]
  head "https://gitlab.com/dave_m/clamtk.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  option "with-perlbrew", "Install using perlbrew's perl"

  depends_on "clamav"
  depends_on "perl"

  def install
    inreplace "lib/App.pm" do |s|
      s.gsub! "/usr/share/pixmaps", "/usr/local/share/pixmaps"
      s.gsub! "/.local/share/Trash", "/.Trash" if OS.mac?
    end
    bin.install "clamtk"
    man1.install "clamtk.1.gz"
    # cd share do
    mkdir "#{share}/applications"
    mkdir "#{share}/metainfo"
    mkdir "#{share}/perl5/vendor_perl/ClamTk"
    mkdir "#{share}/pixmaps"
    # end
    (share/"applications").install "clamtk.desktop"
    (share/"metainfo").install "com.github.davetheunsub.clamtk.appdata.xml"
    (share/"perl5/vendor_perl/ClamTk").install Dir["lib/*.pm"]
    (share/"pixmaps").install Dir["images/*"]
  end

  def post_install
    inreplace "#{bin}/clamtk", "#!/usr/local/opt/perl/bin/perl", "#!/usr/bin/env perl" if build.with?("perlbrew")
  end

  def caveats
    if build.with? "perlbrew"
      <<~EOS
        If you want to install ClamTk to a perlbrew perl, run the following:
        sudo mkdir -p /opt/perl5/perls/perl-*/lib/site_perl/5.*/ClamTk
        sudo cp /usr/local/share/perl5/vendor_perl/ClamTk/*.pm /opt/perl5/perls/perl-*/lib/site_perl/5.*/ClamTk/
      EOS
    end
  end

  test do
    system "which", "clamtk"
  end
end
