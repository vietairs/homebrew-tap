class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for the hvn unknowns kit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e25a3360434352fbfb013e6ca5f1dee907807d8550d58a672c2ff31831c8415e"
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
