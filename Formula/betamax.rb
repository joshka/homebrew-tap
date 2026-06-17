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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.11/betamax-0.1.11-aarch64-apple-darwin.tgz"
      sha256 "e67753c4e4aa281008df4fafbd74f2e0ca96b90d920486823fd8c80f88f70638"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.11/betamax-0.1.11-x86_64-apple-darwin.tgz"
      sha256 "1fe0c8482e12dbd3336622f3fae1aa17de31cf01bc168dc917de0de7c279d8a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.11/betamax-0.1.11-aarch64-unknown-linux-gnu.tgz"
      sha256 "30354e643d73a61f3e869f797bddcd1db35d0519b9b6dd10a3c378a40464a9d8"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.11/betamax-0.1.11-x86_64-unknown-linux-gnu.tgz"
      sha256 "5fb5f09b68d1c427fcaec76d02c371698e54597e4da02d9c69f71a95a645b701"
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
