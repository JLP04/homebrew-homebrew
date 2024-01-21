class Clamtk < Formula
  desc "Easy to use, light-weight, on-demand virus scanner for Linux systems"
  homepage "https://gitlab.com/dave_m/clamtk/-/wikis/home"
  url "https://gitlab.com/dave_m/clamtk/-/archive/c99e28bdc2a7d2fb50f2a5a65b7a3508f16efad8/clamtk-c99e28bdc2a7d2fb50f2a5a65b7a3508f16efad8.tar.gz"
  version "6.18"
  sha256 "b6c12ef4d9f45253ca493e243f37ca306f256244247097ab92f07136bdeceff2"
  license all_of: [
    "BSD-3-Clause",
    any_of: ["GPL-1.0-or-later", "Artistic-2.0"],
  ]
  revision 4
  head "https://gitlab.com/dave_m/clamtk.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256                               ventura:      "95dd50cd63b6eb63538ecd981241765372cf546168f6140b22d0c3ef8ee589c8"
    sha256                               monterey:     "bfe55bb25b49fd53087b577110d352c4d7c5b4d23f79ce9c7e12e636e2bf8484"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dad0a39ef53f464d6b91c7702dfe793207497f0b4654e8abde02d686ae22d288"
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
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.73.tar.gz"
      sha256 "41afb949b5ab95251bed45defcbd3811b75fc41d1b6ba48003fcd7704f86db3c"
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
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.21.tar.gz"
      sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
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
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.11.tar.gz"
      sha256 "0132ddbf03661565ca85050f2a5094fb9263cbbc3ccb1a4d9c41ac9bb083b917"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
      sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.084.tar.gz"
      sha256 "a60d1e04e192363155329560498abd3412c3044295dae092d27fb6e445c71ce1"
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
