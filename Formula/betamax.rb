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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.1/betamax-0.2.1-aarch64-apple-darwin.tgz"
      sha256 "7705ed001b759e2214850bb3c0822ebf64e625983ee8753c4c763f4a40fe4e48"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.1/betamax-0.2.1-x86_64-apple-darwin.tgz"
      sha256 "763c416276e73aa4e21e50fa10e90f4d1d563431395f2043a7790bd2a5042cb2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.1/betamax-0.2.1-aarch64-unknown-linux-gnu.tgz"
      sha256 "46588bee08d32f865bb5c3b0108da885782c594e1e326dc13373f8352fad5080"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.1/betamax-0.2.1-x86_64-unknown-linux-gnu.tgz"
      sha256 "e0547c478366378262e528994a891d1e9d99f98d469be2489aa25bd68927a7a7"
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
