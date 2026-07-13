class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for the hvn unknowns kit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ebcbf5dbb8ea4fe2487f71acf9b945434f1b0972fb204ff1318a38a9ebd677f2"
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
