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
    sha256 arm64_golden_gate: "eca7ad7d99ba14001d1b1b7b1bec8b0a8c829a01ef8c34a3a4fe9def457d5d93"
    sha256 arm64_tahoe:       "53203f7360a83b1f3892335d2986d536d4eaa14024f30e1ca6f2c36163648ccf"
    sha256 arm64_sequoia:     "9104990d0b9aa2c9b6961b56219379a220d921d94b3290331f6a0f9080bd8445"
    sha256 arm64_linux:       "b38d7092f77b1efe07a6564b7a2c27a748073464a7cb4e9485e51759fbd8ee05"
    sha256 x86_64_linux:      "c312786b72a026e3b63b3f0c457d56093b4fc8f58f70abbe2c25bba4285c6986"
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
