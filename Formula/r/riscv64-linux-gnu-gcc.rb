class Riscv64LinuxGnuGcc < Formula
  desc "GNU compiler collection for riscv64-linux-gnu"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  compatibility_version 1

  livecheck do
    formula "gcc"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-linux-gnu-binutils"
  depends_on "zstd"

  on_linux do
    depends_on "glibc" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    mkdir "riscv64-linux-gnu-gcc-build" do
      target = "riscv64-linux-gnu"
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{formula_opt_bin("riscv64-linux-gnu-binutils")}/riscv64-linux-gnu-as",
                             "--with-ld=#{formula_opt_bin("riscv64-linux-gnu-binutils")}/riscv64-linux-gnu-ld",
                             "--with-system-zlib",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      if OS.mac?
        system "make", "-i", "distclean"
        truetarget = "riscv64-unknown-elf"
        build_time_tools = "#{formula_opt_prefix("riscv64-linux-gnu-binutils")}/riscv64-linux-gnu/bin"
        system "../configure", "--target=#{truetarget}",
                              "--prefix=#{prefix}",
                              "--infodir=#{info}/#{target}",
                              "--disable-nls",
                              "--without-isl",
                              "--without-headers",
                              "--with-as=#{formula_opt_bin("riscv64-linux-gnu-binutils")}/riscv64-linux-gnu-as",
                              "--with-ld=#{formula_opt_bin("riscv64-linux-gnu-binutils")}/riscv64-linux-gnu-ld",
                              "--with-build-time-tools=#{build_time_tools}",
                              "--with-system-zlib",
                              "--enable-languages=c,c++"
      end
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
    objdump = "#{formula_opt_bin("riscv64-linux-gnu-binutils")}/riscv64-linux-gnu-objdump"
    system bin/"riscv64-linux-gnu-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{objdump} -a test-c.o")
  end
end
