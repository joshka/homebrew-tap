class Betamax < Formula
  desc "Rust-first VHS-style terminal capture CLI"
  homepage "https://www.joshka.net/betamax/"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^betamax-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.1/betamax-0.4.1-aarch64-apple-darwin.tgz"
      sha256 "c191d7ceb203b742f8c84cfc46b296b29e68ed97f14d27c5967eb20433427d32"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.1/betamax-0.4.1-x86_64-apple-darwin.tgz"
      sha256 "289dd30d6cea7b4802213136539bcdd3f36e9b99fb7869f8031fd674dcd56982"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.1/betamax-0.4.1-aarch64-unknown-linux-gnu.tgz"
      sha256 "eb13c280e63607c27a41775edad59f9ab2d6691ea5225dfe67180ab66ad84ce9"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.1/betamax-0.4.1-x86_64-unknown-linux-gnu.tgz"
      sha256 "3375d83756c07a119cbb97a1219e6c268dafcc55d9c883aa090e893a1a3f9f71"
    end
  end

  def install
    bin.install "betamax"
  end

  def caveats
    <<~EOS
      Betamax's video output requires ffmpeg:
        brew install ffmpeg

      This formula installs Betamax's upstream binary release archive. Source builds
      require zig@0.15 because Betamax's vendored libghostty-vt build requires Zig
      0.15.2.
    EOS
  end

  test do
    assert_match "betamax #{version}", shell_output("#{bin}/betamax --version")
    assert_match "Rust-first VHS-style terminal capture CLI", shell_output("#{bin}/betamax --help")
  end
end
