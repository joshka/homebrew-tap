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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-aarch64-apple-darwin.tgz"
      sha256 "72b7912e6f949e347a702afb004ea9e688a445fc3ee157410484d8f872a174ed"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-x86_64-apple-darwin.tgz"
      sha256 "4760832176e9c8248d6c3ab4ec9ca78254645a71cb77a47e6017ecf1a5436055"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-aarch64-unknown-linux-gnu.tgz"
      sha256 "e7c055f77b9012b356f537543f98009ffc24a67c7a354e32903716b7c794d070"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-x86_64-unknown-linux-gnu.tgz"
      sha256 "ef7be1bbe38ac600571be6cdd757d6f582c78f137b447dd74cf7059a2fdd589d"
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
