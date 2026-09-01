class HvnAgentkit < Formula
  desc "hak (Hvn-AgentKit) — installer CLI for hvn-agentkit across coding CLIs"
  homepage "https://github.com/vietairs/hvn-cli"
  url "https://github.com/vietairs/hvn-cli-dist/releases/download/v2.12.0/hak-v2.12.0-dist.tar.gz"
  sha256 "c546b6b9a3f1c9ea4a596da8927e70869a2e003ce47e49d74d5b53391bd0e606"

  # The install step only copies prebuilt files and writes two shell shims — nothing is
  # compiled. Without a bottle, Homebrew still treats installation as a build from source
  # and runs `fatal_build_from_source_checks`, which hard-fails on any macOS whose
  # `Xcode.minimum_version` outranks the installed Xcode (every prerelease macOS, where that
  # minimum is derived as "<macos>.0"). Shipping a bottle skips those checks entirely.
  # The bottle is platform-independent: `:any` because the shims embed a Cellar path that
  # Homebrew rewrites from its @@HOMEBREW_CELLAR@@ placeholder at pour time.
  bottle do
    root_url "https://github.com/vietairs/hvn-cli-dist/releases/download/v2.12.0"
    sha256 cellar: :any, all: "53d9d0d78fd964468bc0a2d8396f4487e04284bb23bfe126f4c80aedd506eff7"
  end

  # hak 2.0.0 raised its engine floor to Node >= 22. Homebrew's `node` formula is well past that,
  # so the bare dependency still resolves — but a user on an older pinned node will now fail at
  # runtime rather than install time.
  depends_on "node"

  def install
    libexec.install Dir["*"]

    # cli/hvn.cjs is an esbuild bundle that already includes the dashboard
    # server (express) deps; cli/dashboard/ui/dist ships pre-built static
    # assets. No npm install/build needed at install time.

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
