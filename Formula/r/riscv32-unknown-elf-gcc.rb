class Riscv32UnknownElfGcc < Formula
  desc "GNU compiler collection for riscv32-unknown-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  compatibility_version 1

  livecheck do
    formula "gcc"
  end

  bottle do
    root_url "https://ghcr.io/v2/jlp04/homebrew"
    sha256 arm64_golden_gate: "0aac783218415d8f17953081de7b1ed2fb8ed609c366ca958a17222a69bf0c4e"
    sha256 arm64_tahoe:       "6f93a5dcf4fcf0037346ef794164a111d0ab8aed56ac9d1aba863f64570dcb1a"
    sha256 arm64_sequoia:     "6ef70e35da1978d5527342480ec7be6aa0960d2b0a7e4848d2283f3ed6aa7df7"
    sha256 arm64_linux:       "7975b8248094af47d2b39df2266a030da522d502f2d9822654a1226bd68daa73"
    sha256 x86_64_linux:      "1100da512af3c7f84d293fc293981aebd422fa2bcd204ee1ca34bbe6f831c7f3"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv32-unknown-elf-binutils"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "riscv32-unknown-elf"
    mkdir "riscv32-unknown-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{formula_opt_bin("riscv32-unknown-elf-binutils")}/riscv32-unknown-elf-as",
                             "--with-ld=#{formula_opt_bin("riscv32-unknown-elf-binutils")}/riscv32-unknown-elf-ld",
                             "--with-system-zlib",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      rm_r(share/"man/man7")
    end
  end

  test do
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C
    objdump = "#{formula_opt_bin("riscv32-unknown-elf-binutils")}/riscv32-unknown-elf-objdump"
    system bin/"riscv32-unknown-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-littleriscv",
                 shell_output("#{objdump} -a test-c.o")
  end
end
