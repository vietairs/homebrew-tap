class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for the hvn unknowns kit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0b8c9b71df6fa8b5c85a098bea1e4daf1623c0ca97f42eef2279ca5b1ad4ff8b"
  depends_on "node"

  def install
    libexec.install Dir["*"]
    %w[hvn-agentkit hak].each do |cmd|
      (bin/cmd).write <<~SH
        #!/bin/bash
        exec node "#{libexec}/cli/hvn.mjs" "$@"
      SH
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hak --version")
  end
end
