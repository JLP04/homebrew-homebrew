class Riscv64LinuxGnuBinutils < Formula
  desc "GNU Binutils for riscv64-linux-gnu cross development"
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
    sha256 arm64_golden_gate: "8639072541bf342ab308ab246f4594a4eb94fbdda5724b1659002a077a32b5bc"
    sha256 arm64_tahoe:       "6fb27d0c37223c8f75e3a40b5f22ec3149af2713b75ef54b4627a1e495df13b9"
    sha256 arm64_sequoia:     "288e690de3a5cf6797a3ccd9fa9098173d3b3bee4a2ce5ee5cf5bbd226004fe9"
    sha256 arm64_linux:       "598563f3ecd337b4046b330d2ea2e65f0aea988ef9b261db767e74682d769e1c"
    sha256 x86_64_linux:      "d09752a3f1b2a2a2a338fb7c648a760c21bb468ed2f55bf81a1e5c4285c9c766"
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
    target = "riscv64-linux-gnu"
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

    system bin/"riscv64-linux-gnu-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{bin}/riscv64-linux-gnu-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv64-linux-gnu-c++filt _Z1fv")
  end
end
