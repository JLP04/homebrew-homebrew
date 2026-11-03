class Riscv32UnknownElfBinutils < Formula
  desc "GNU Binutils for riscv32-unknown-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    formula "binutils"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    rebuild 1
    sha256 arm64_golden_gate: "c081452ae69c29342192fe56d653d9fb9b5792f9b1fd67a0f7897dda9978bc38"
    sha256 arm64_tahoe:       "0027d6cd7f60d21cb3e46e0018a734ad2b6b06bf38e8d03099171accdd2e318d"
    sha256 arm64_sequoia:     "a3104317d6210454e7db55209590b8f73f79ee24b0ec7c9e10d44fb8b7ab72de"
    sha256 arm64_linux:       "aa0ad9ed7383e600dcde828ce6220bdb677bc98526fecd4389ea324785b73f19"
    sha256 x86_64_linux:      "5aeeae0441fa43bc42c08719466401d5c196c6c3ee19a63209ceed11116a9839"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    target = "riscv32-unknown-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text
      .globl _start
      _start:
          li a7, 93
          li a0, 0
          ecall
    ASM

    system bin/"riscv32-unknown-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littleriscv",
                 shell_output("#{bin}/riscv32-unknown-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv32-unknown-elf-c++filt _Z1fv")
  end
end
