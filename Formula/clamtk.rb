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

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any_skip_relocation, monterey:     "8f7c4bc1bb48f3fcbe58ca3cde369e9cea81848b7f269b44511b7699a3b435db"
    sha256 cellar: :any_skip_relocation, big_sur:      "3103d6dbacdad5c1e7ed8d7aac1ea8faca84325e117d7eda0fed24d032775350"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d8cb4856a38dad966bc3a947a641b129b9540070da0b1b3c354647b46462232b"
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
        If ClamTk complains about being unable to find the virus definitions, run the following commands:
        ln -s /usr/local/var/lib/clamav/bytecode.cvd ~/.clamtk/db/cytecode.cvd
        ln -s /usr/local/var/lib/clamav/daily.cvd ~/.clamtk/db/daily.cvd
        ln -s /usr/local/var/lib/clamav/main.cvd ~/.clamtk/main.cvd

        If you want to install ClamTk to a perlbrew perl, run the following:
        sudo mkdir -p /opt/perl5/perls/perl-*/lib/site_perl/5.*/ClamTk
        sudo cp /usr/local/share/perl5/vendor_perl/ClamTk/*.pm /opt/perl5/perls/perl-*/lib/site_perl/5.*/ClamTk/
      EOS
    else
      <<~EOS
        If ClamTk complains about being unable to find the virus definitions, run the following commands:
        ln -s /usr/local/var/lib/clamav/bytecode.cvd ~/.clamtk/db/cytecode.cvd
        ln -s /usr/local/var/lib/clamav/daily.cvd ~/.clamtk/db/daily.cvd
        ln -s /usr/local/var/lib/clamav/main.cvd ~/.clamtk/main.cvd
      EOS
    end
  end

  test do
    system "which", "clamtk"
  end
end
