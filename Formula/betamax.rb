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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.1/betamax-0.3.1-aarch64-apple-darwin.tgz"
      sha256 "b03abe380a660abb7c13c4d678b9d42b7e2d99219a8a9b93358fd95627495c8c"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.1/betamax-0.3.1-x86_64-apple-darwin.tgz"
      sha256 "9130afcb35a604db0885c8193307dff271b4c7d7987382dd633e0c0244dcbda6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.1/betamax-0.3.1-aarch64-unknown-linux-gnu.tgz"
      sha256 "fa0c1a324ebeb837c752620c15276c838295922f4eaa60475a566c8d56a4fec3"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.3.1/betamax-0.3.1-x86_64-unknown-linux-gnu.tgz"
      sha256 "3e8cd7639242b69c2a9c35273072a94a06039b8319fc34fc0649689a741da6b1"
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
