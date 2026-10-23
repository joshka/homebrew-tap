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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.2/betamax-0.2.2-aarch64-apple-darwin.tgz"
      sha256 "a043f74ecfcab1b34cb665defd35c0708794eeb1ba6ebbad7f28c2dd0e9b5f44"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.2/betamax-0.2.2-x86_64-apple-darwin.tgz"
      sha256 "0807ff7806e67b167c3e17b5c9a2c117c4b44c391ac261efe42433d1c149b3f0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.2/betamax-0.2.2-aarch64-unknown-linux-gnu.tgz"
      sha256 "2e5ce15344bc20f98fdfe511174c6914c77f0f5056bd923befaf37bded851ae7"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.2.2/betamax-0.2.2-x86_64-unknown-linux-gnu.tgz"
      sha256 "217be876c44898b372183815fd6e68bc2e3a1a344f86d43889adfc0d3f421791"
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
