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
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.21/betamax-0.1.21-aarch64-apple-darwin.tgz"
      sha256 "455dc756d1f66aaf626c530fe0f657e4d8a91c5b714ea44d2d1fd0f257514a39"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.21/betamax-0.1.21-x86_64-apple-darwin.tgz"
      sha256 "733e35f1395c13d163c56340b61a9fe859bad9273a46117c9c880ad7802cece2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.21/betamax-0.1.21-aarch64-unknown-linux-gnu.tgz"
      sha256 "3ec76b4ef87721fad7f4db28eb8be34f31f0fe97c41968c60720a92399c1f1e9"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.21/betamax-0.1.21-x86_64-unknown-linux-gnu.tgz"
      sha256 "8dd5893d8d74cdf28ff4052be31b2b72810f40bf8c08385b84e53c572209848a"
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
