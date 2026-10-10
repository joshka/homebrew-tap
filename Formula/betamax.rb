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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.22/betamax-0.1.22-aarch64-apple-darwin.tgz"
      sha256 "0fe9e07cf963a668725508fd5afa62120245950fded75718898546c4de22f98e"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.22/betamax-0.1.22-x86_64-apple-darwin.tgz"
      sha256 "110cf1274cfa43cb5e1528eca359531da048ae540f6d7fc37b5e24c859286bbc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.22/betamax-0.1.22-aarch64-unknown-linux-gnu.tgz"
      sha256 "da7fc6dacb2db9ae12034698422ed1f8b0467f5b46d79fdb889689b61cfc97fd"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.22/betamax-0.1.22-x86_64-unknown-linux-gnu.tgz"
      sha256 "497c0bbf6da724e90be49e48ade317d99567e4b03e4e86f03c0dac691ec6358f"
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
