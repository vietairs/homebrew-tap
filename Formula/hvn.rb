class Hvn < Formula
  desc "Installer CLI for the hvn unknowns kit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b68fe07d9b2d69daba5572ef27a4f5df7c5ece3e65fa106d4f886577de219478"
  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"hvn").write <<~SH
      #!/bin/bash
      exec node "#{libexec}/cli/hvn.mjs" "$@"
    SH
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/hvn --version")
  end
end
