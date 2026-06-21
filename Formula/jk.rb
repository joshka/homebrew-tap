class Jk < Formula
  desc "Log-first terminal UI for Jujutsu"
  homepage "https://github.com/joshka/jk"
  url "https://static.crates.io/crates/jk/jk-0.2.2.crate"
  sha256 "4f6f73be6acb921cee52324f18d2b7b1e8325086fb4fca0f09e0ce5a1627580a"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://crates.io/api/v1/crates/jk"
    strategy :json do |json|
      json.dig("crate", "max_stable_version")
    end
  end

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "jk #{version}", shell_output("#{bin}/jk --version")
    assert_match "A log-first terminal UI for Jujutsu", shell_output("#{bin}/jk --help")
  end
end
