class Clamtk < Formula
  desc "Easy to use, light-weight, on-demand virus scanner for Linux systems"
  homepage "https://gitlab.com/dave_m/clamtk/-/wikis/home"
  url "https://gitlab.com/dave_m/clamtk/-/archive/937251b43140cc2a756959edbc0ec0f01dac2551/clamtk-937251b43140cc2a756959edbc0ec0f01dac2551.tar.gz"
  version "6.18"
  sha256 "a3d85a3be8cac4985a4b84656a1a6f2f81d9fc1a278f29999e503758665c92ba"
  license all_of: [
    "BSD-3-Clause",
    any_of: ["GPL-1.0-or-later", "Artistic-2.0"],
  ]
  revision 11
  head "https://gitlab.com/dave_m/clamtk.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256                               ventura:      "45c1a261133f00fd01c7bceac1b00c37172f83bfe908307475987678553dad50"
    sha256                               monterey:     "82854e6113343e51ff78e8e1024877a653f0e7456291078e183451427536b72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9e19b3ef847ab726ede59147d3855f4b9c91a8c0b55c6f3ba856f7bb5cb5e36c"
  end
  option "with-perlbrew", "Install using perlbrew's perl"

  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "libpng" => :build
  depends_on "libx11" => :build
  depends_on "libxau" => :build
  depends_on "libxcb" => :build
  depends_on "libxdmcp" => :build
  depends_on "libxext" => :build
  depends_on "libxrender" => :build
  depends_on "pixman" => :build
  depends_on "pkg-config" => :build
  depends_on "vtk" => :build
  depends_on "xorgproto" => :build
  depends_on "cairo"
  depends_on "clamav"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "perl"

  if build.without? "perlbrew"

    resource "ExtUtils::Depends" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/ExtUtils-Depends-0.8001.tar.gz"
      sha256 "673c4387e7896c1a216099c1fbb3faaa7763d7f5f95a1a56a60a2a2906c131c5"
    end

    resource "ExtUtils::PkgConfig" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/ExtUtils-PkgConfig-1.16.tar.gz"
      sha256 "bbeaced995d7d8d10cfc51a3a5a66da41ceb2bc04fedcab50e10e6300e801c6e"
    end

    resource "Glib" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/Glib-1.3294.tar.gz"
      sha256 "d715f5a86bcc187075de85e7ae5bc07b0714d6edc196a92da43986efa44e5cbb"
    end

    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.76.tar.gz"
      sha256 "75c2e57d6102eea540f3611b56fd86268a59b022dd00ea6562ac36412fcdf8e1"
    end

    resource "HTTP::Message" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.45.tar.gz"
      sha256 "01cb8406612a3f738842d1e97313ae4d874870d1b8d6d66331f16000943d4cbe"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
      sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.26.tar.gz"
      sha256 "622bb95f588e25923a504c62687f4c8c7d7c3e0cc247449edf146228e5ae686f"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end

    resource "LWP::Protocol::https" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.12.tar.gz"
      sha256 "7dd36d3a4eacfa143a47a2bbbc56ea9413887e2d7376c1d35bbbb2be912b616c"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
      sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.085.tar.gz"
      sha256 "95b2f7c0628a7e246a159665fbf0620d0d7835e3a940f22d3fdd47c3aa799c2e"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
      sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
    end

    resource "Text::CSV" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.04.tar.gz"
      sha256 "4f80122e4ea0b05079cad493e386564030f18c8d7b1f9af561df86985a653fe3"
    end

    resource "JSON" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end

    resource "Locale::gettext" do
      url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/Locale-gettext-1.07.tar.gz"
      sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
    end

    resource "Gtk3" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/Gtk3-0.038.tar.gz"
      sha256 "70dc4bf2aa74981c79e15fd298d998e05a92eba4811f1ad5c9f1f4de37737acc"
    end

    resource "Cairo" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/Cairo-1.109.tar.gz"
      sha256 "8219736e401c2311da5f515775de43fd87e6384b504da36a192f2b217643077f"
    end

    resource "Cairo::GObject" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/Cairo-GObject-1.005.tar.gz"
      sha256 "8d896444d71e1d0bca3d24e31e5d82bd0d9542aaed91d1fb7eab367bce675c50"
    end

    resource "Glib::Object::Introspection" do
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/Glib-Object-Introspection-0.051.tar.gz"
      sha256 "6569611dcc80ac1482c7c22264b1ae8c9c351d4983511eb9a6c5f47a10150089"
    end
  end

  def install
    if build.without? "perlbrew"
      ENV.prepend_create_path "PERL5LIB", "share/perl5/vendor_perl"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          ENV["PERL_MM_USE_DEFAULT"] = "1"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end
    inreplace "lib/App.pm" do |s|
      s.gsub! "/usr/share/pixmaps", HOMEBREW_PREFIX/"share/pixmaps"
      s.gsub! "/.local/share/Trash", "/.Trash" if OS.mac?
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! "/etc", HOMEBREW_PREFIX/"etc/clamav"
    end
    bin.install "clamtk" if build.with? "perlbrew"
    if build.without? "perlbrew"
      (libexec/"bin").install "clamtk"
      (bin/"clamtk").write_env_script("#{libexec}/bin/clamtk", PERL5LIB: ENV["PERL5LIB"])
    end
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
        If you want to install ClamTk to a perlbrew perl, run the following (you will need to install cairo, pkg-config, and vtk to build the perl modules):
        for d in /opt/perl5/perls/perl-*/lib/site_perl/5.*; do
          sudo mkdir -p "$d"/ClamTk
        done
        sudo cp $(brew --prefix)/share/perl5/vendor_perl/ClamTk/*.pm /opt/perl5/perls/perl-*/lib/site_perl/5.*/ClamTk/
        sudo cpan -i ExtUtils::Depends ExtUtils::PkgConfig Glib LWP::UserAgent HTTP::Message Clone URI HTTP::Date Try::Tiny LWP::Protocol::https Net::HTTP IO::Socket::SSL Net::SSLeay Text::CSV JSON Locale::gettext Gtk3 Cairo Cairo::GObject Glib::Object::Introspection
      EOS
    end
  end

  test do
    if OS.mac?
      (testpath/"test").write <<~EOS
        #!#{HOMEBREW_PREFIX}/opt/perl/bin/perl
        use utf8;
        $| = 1;

        use lib '.';
        use ClamTk::Analysis;
        use ClamTk::App;
        use ClamTk::Assistant;
        use ClamTk::GUI;
        use ClamTk::History;
        use ClamTk::Icons;
        use ClamTk::Network;
        use ClamTk::Prefs;
        use ClamTk::Results;
        use ClamTk::Scan;
        use ClamTk::Schedule;
        use ClamTk::Settings;
        use ClamTk::Shortcuts;
        use ClamTk::Startup;
        use ClamTk::Update;
        use ClamTk::Quarantine;
        use ClamTk::Whitelist;

        use Encode 'decode';
        use Locale::gettext;
        use POSIX 'locale_h';
        textdomain( 'clamtk' );
        setlocale( LC_ALL, '' );

        setlocale( LC_TIME, 'C' );
        bind_textdomain_codeset( 'clamtk', 'UTF-8' );

        my $arg = decode ( 'utf8', $ARGV[0] );

        my $trash_dir = ClamTk::App->get_path( 'trash_dir' );
        if ( $arg eq '//' ) {
          $arg = $trash_dir;
        } elsif ( $arg =~ m#^//(.*?)$# ) {
          my $trash_dir_files = ClamTk::App->get_path( 'trash_dir_files' );
          if ( -e "$trash_dir_files/$1" ) {
            $arg = "$trash_dir_files/$1";
          }
        }

        ClamTk::Prefs->structure;

        ClamTk::Prefs->custom_prefs;
      EOS
    end
    if OS.linux?
      (testpath/"test").write <<~EOS
        #!#{HOMEBREW_PREFIX}/opt/perl/bin/perl
        use utf8;
        $| = 1;

        use lib '.';
        use ClamTk::Analysis;
        use ClamTk::App;
        use ClamTk::Assistant;
        use ClamTk::History;
        use ClamTk::Icons;
        use ClamTk::Network;
        use ClamTk::Prefs;
        use ClamTk::Results;
        use ClamTk::Scan;
        use ClamTk::Schedule;
        use ClamTk::Settings;
        use ClamTk::Shortcuts;
        use ClamTk::Startup;
        use ClamTk::Update;
        use ClamTk::Quarantine;
        use ClamTk::Whitelist;

        use Encode 'decode';
        use Locale::gettext;
        use POSIX 'locale_h';
        textdomain( 'clamtk' );
        setlocale( LC_ALL, '' );

        setlocale( LC_TIME, 'C' );
        bind_textdomain_codeset( 'clamtk', 'UTF-8' );

        my $arg = decode ( 'utf8', $ARGV[0] );

        my $trash_dir = ClamTk::App->get_path( 'trash_dir' );
        if ( $arg eq '//' ) {
          $arg = $trash_dir;
        } elsif ( $arg =~ m#^//(.*?)$# ) {
          my $trash_dir_files = ClamTk::App->get_path( 'trash_dir_files' );
          if ( -e "$trash_dir_files/$1" ) {
            $arg = "$trash_dir_files/$1";
          }
        }

        ClamTk::Prefs->structure;

        ClamTk::Prefs->custom_prefs;
      EOS
    end
    inreplace "test", "#!#{HOMEBREW_PREFIX}/opt/perl/bin/perl", "#!/usr/bin/env perl" if build.with? "perlbrew"
    ENV.prepend_create_path "PERL5LIB", "#{share}/perl5/vendor_perl" if build.without? "perlbrew"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    chmod "+x", "test"
    system "./test"
  end
end
