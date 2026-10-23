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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.0/betamax-0.3.0-aarch64-apple-darwin.tgz"
      sha256 "e9f6c886484b565bb40fdb355299e7d8173c7b93efb3c4258c336d2797eccb2c"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.0/betamax-0.3.0-x86_64-apple-darwin.tgz"
      sha256 "f61192468111cd5f96e2f20df87680f0eb0c3ffb10226aadf7bd910cdb77d6b5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.0/betamax-0.3.0-aarch64-unknown-linux-gnu.tgz"
      sha256 "ed7f96e3b39710151d46f2615c781869d2c6421e1a9b7e6e9298ceb456cd3d83"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.0/betamax-0.3.0-x86_64-unknown-linux-gnu.tgz"
      sha256 "bec9a8e3f2b058e1279ede700ab100829efc6675cb54c2179167949bfdb01ad2"
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
