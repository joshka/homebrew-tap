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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.0/betamax-0.2.0-aarch64-apple-darwin.tgz"
      sha256 "ae770ea976bf37f67162e42d8db64ce2c0a548619ea20fc31c63f5d8329410e4"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.0/betamax-0.2.0-x86_64-apple-darwin.tgz"
      sha256 "1b40acdc20a809100a4b8528e138399e7efa673f94a257931e4577fa30a8286a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.0/betamax-0.2.0-aarch64-unknown-linux-gnu.tgz"
      sha256 "f0e58dd6112f879c759651a951023ee65b5d0ea1f0ffa58fdd2935dc7164c1b0"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.0/betamax-0.2.0-x86_64-unknown-linux-gnu.tgz"
      sha256 "a447edfe5a69284d02f8b8c405b80d40c9106d92492939fac9cc1410bd4e3d1d"
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
