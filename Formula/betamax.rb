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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.15/betamax-0.1.15-aarch64-apple-darwin.tgz"
      sha256 "5f600aae86eb02238a8d583b80b76f965b0f7ba413d8d4aad9e57318f73f6d30"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.15/betamax-0.1.15-x86_64-apple-darwin.tgz"
      sha256 "36ce0ebe6ffb3a55f7ca176612f128d4f3c5c46c9ee29d26aa8849c949a9f650"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.15/betamax-0.1.15-aarch64-unknown-linux-gnu.tgz"
      sha256 "3c1f5e3fa7a05f0fbd5e8a7cb65361e15ee44576e40f106ba92b0d00b75bcc44"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.15/betamax-0.1.15-x86_64-unknown-linux-gnu.tgz"
      sha256 "e91f61d5da5835ce1520e9a9d6b5096a5b913ad5b33f7d552ebe54a13b214e3c"
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
