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
  revision 46
  head "https://gitlab.com/dave_m/clamtk.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 cellar: :any,                 arm64_tahoe:   "272ced924ec6ea6bd6d45fca176108909a0a7559d389f25c94cdc467332df059"
    sha256 cellar: :any,                 arm64_sequoia: "0b34ec4bfbf40485eb8cb095f8facd2e43196d972a424618896e4f16116d557c"
    sha256 cellar: :any,                 arm64_sonoma:  "ceda71d052daeb4b7fe4d7f84738607e86df41df013599a5093db258af27ebcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f081ec81bf6c01a33d0125b04c5278ec18342627fe203c5b3eabcc75bffb4d86"
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
  depends_on "pkgconf" => :build
  depends_on "vtk" => :build
  depends_on "xorgproto" => :build
  depends_on "cairo"
  depends_on "clamav"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "openssl@3"
  depends_on "perl"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libffi"
  end

  if build.without? "perlbrew"

    resource "ExtUtils::Depends" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/ExtUtils-Depends-0.8002.tar.gz"
      sha256 "02b9a46450050ce19b325b23e46bb4ec644229d7f2d95044f67a86d8efacdc29"
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
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.81.tar.gz"
      sha256 "ab30552f194e8b5ae3ac0885132fd1d4ea04c4c7fe6555765b98f01af70c1736"
    end

    resource "HTTP::Message" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.01.tar.gz"
      sha256 "82b79ce680251045c244ee059626fecbf98270bed1467f0175ff5ea91071437e"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
      sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
      sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
    end

    resource "LWP::Protocol::https" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.15.tar.gz"
      sha256 "44eec2da147ba0511090871b0ca82f69794376bc31e8c76d1040961ba57f59b8"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
      sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.098.tar.gz"
      sha256 "b38473be20256b1a06447dd6769ad162bfad6a258234ed2c7e2e1819c16c4df7"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
      sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
    end

    resource "Text::CSV" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.06.tar.gz"
      sha256 "dfcaec925a788b0ba41e51bc6d16e21b0e98b4c7af9b79395090add75f5e506f"
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
      url "https://cpan.metacpan.org/authors/id/X/XA/XAOC/Glib-Object-Introspection-0.052.tar.gz"
      sha256 "555b4f1308939bb3141ea4570ad12e04e27c23329c302c9dc8725409e1049111"
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
    inreplace bin/"clamtk", "#!#{HOMEBREW_PREFIX}/opt/perl/bin/perl", "#!/usr/bin/env perl" if build.with? "perlbrew"
  end

  def caveats
    <<~EOS
      If you want to install ClamTk to a perlbrew perl, run the following (you will need to install cairo, pkgconf, and vtk to build the perl modules):
      for d in "$PERLBREW_ROOT"/perls/perl-*/lib/site_perl/5.*; do
        sudo mkdir -p "$d"/ClamTk
        sudo cp $(brew --prefix)/share/perl5/vendor_perl/ClamTk/*.pm "$d"/ClamTk/
      done
      sudo cpan -i ExtUtils::Depends ExtUtils::PkgConfig Glib LWP::UserAgent HTTP::Message Clone URI HTTP::Date Try::Tiny LWP::Protocol::https Net::HTTP IO::Socket::SSL Net::SSLeay Text::CSV JSON Locale::gettext Gtk3 Cairo Cairo::GObject Glib::Object::Introspection
    EOS
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
    if build.without? "perlbrew"
      ENV.prepend_create_path "PERL5LIB", "#{share}/perl5/vendor_perl"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    end
    chmod "+x", "test"
    system "./test"
  end
end
