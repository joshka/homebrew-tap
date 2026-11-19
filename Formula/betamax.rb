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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.0/betamax-0.4.0-aarch64-apple-darwin.tgz"
      sha256 "83ce5be5d1eb2416015b9c3006260aa8bc5fe8c1074d4e64adfcf9aecaa8832d"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.0/betamax-0.4.0-x86_64-apple-darwin.tgz"
      sha256 "8647edf9a6f39272da9b36a474423ef634bd93d69eddfa357be4e6565f6fc5e3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.0/betamax-0.4.0-aarch64-unknown-linux-gnu.tgz"
      sha256 "c681f900e70f87705c067c7af5f6e256996783d5b281c71797e1fcffe2a84035"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.4.0/betamax-0.4.0-x86_64-unknown-linux-gnu.tgz"
      sha256 "88ee8421247912b91c05da1231d2316afb01ae39d486f28ecd3bf1a441cd640a"
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
