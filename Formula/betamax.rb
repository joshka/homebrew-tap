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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.13/betamax-0.1.13-aarch64-apple-darwin.tgz"
      sha256 "87cc6964549ccfef2f85e9d00b22d09c4d493ce7abc5c0a9fad948ccc39c8949"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.13/betamax-0.1.13-x86_64-apple-darwin.tgz"
      sha256 "18d24929dcdc1c6094656fcfe91206a981c85be68b82e1ec15ed4e82bf4056f4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.13/betamax-0.1.13-aarch64-unknown-linux-gnu.tgz"
      sha256 "5368a3be8976c356baadf4c89f84ecf2980c429beacc3b88011e8b88357fce36"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.13/betamax-0.1.13-x86_64-unknown-linux-gnu.tgz"
      sha256 "942145b2cba625017e3c890642e9a566c4fcbea7cee756c5a5915a6c40c19349"
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
