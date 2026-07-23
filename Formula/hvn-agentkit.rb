class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for hvn-agentkit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli-dist/releases/download/v1.10.1/hak-v1.10.1-dist.tar.gz"
  sha256 "223aeb5d5879e05c96f793bbf283d95046a22ad83ecb12c3d11581e2b3f16152"
  depends_on "node"

  # The release artifact is a prebuilt, bundled+minified binary — no source,
  # no npm install/build needed at install time (unlike the old source
  # tarball). vietairs/hvn-cli's source repo is private; vietairs/hvn-cli-dist
  # ships only compiled output.
  def install
    libexec.install Dir["*"]

    %w[hvn-agentkit hak].each do |cmd|
      (bin/cmd).write <<~SH
        #!/bin/bash
        exec node "#{libexec}/cli/hvn.cjs" "$@"
      SH
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hak --version")
  end
end
