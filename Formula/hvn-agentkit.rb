class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for hvn-agentkit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "50f967d0256bcd412d15d4d31ba71a14b3e95b0a9e7c055d0c0e118b8e200b79"
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
        exec node "#{libexec}/cli/hvn.mjs" "$@"
      SH
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hak --version")
  end
end
