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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.14/betamax-0.1.14-aarch64-apple-darwin.tgz"
      sha256 "7c8310410efd51b6ba3857ab3233a36cbbdc6bcb114e736e0facff284364462f"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.14/betamax-0.1.14-x86_64-apple-darwin.tgz"
      sha256 "791118d7b776d8e252b4a6188003edfcb6457c1a8e272a520fdc397abccac606"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.14/betamax-0.1.14-aarch64-unknown-linux-gnu.tgz"
      sha256 "a36a33e045bc371edc8fefda7c3a284dbfc5dc7aa266b697ca90ce75284eb851"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.14/betamax-0.1.14-x86_64-unknown-linux-gnu.tgz"
      sha256 "c79cb148a9b04295e76eff316de74447bf1c646af35e0944be63bd8e49fd8d0f"
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
