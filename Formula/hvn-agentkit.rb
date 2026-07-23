class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for hvn-agentkit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli-dist/releases/download/v1.10.1/hak-v1.10.1-dist.tar.gz"
  sha256 "223aeb5d5879e05c96f793bbf283d95046a22ad83ecb12c3d11581e2b3f16152"
  depends_on "node"

  def install
    libexec.install Dir["*"]

    # Pre-build the dashboard UI at install time. `hak dashboard` builds on first
    # run when missing, but the Homebrew Cellar is read-only after install, so we
    # install its (isolated) deps and build the Vite bundle here instead — the
    # runtime build-on-install check then finds them present and no-ops.
    if (libexec/"cli/dashboard").directory?
      system "npm", "--prefix", libexec/"cli/dashboard", "install"
      system "npm", "--prefix", libexec/"cli/dashboard/ui", "install"
      system "npm", "--prefix", libexec/"cli/dashboard/ui", "run", "build"
    end

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
