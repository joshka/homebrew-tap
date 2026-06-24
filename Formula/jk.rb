class Jk < Formula
  desc "Jj-native terminal UI for Jujutsu"
  homepage "https://github.com/joshka/jk"
  url "https://static.crates.io/crates/jk/jk-0.2.7.crate"
  sha256 "2a1ab83b0158dd7e87146af09990b69369e5ba0d9053548cfd51aa5079db0491"
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
    assert_match "A jj-native terminal UI for Jujutsu", shell_output("#{bin}/jk --help")
  end
end
