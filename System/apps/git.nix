# ── System/apps/git.nix ──────────────────────────────────────────────────────
# Git identity and sensible defaults.
{ ... }:
{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "reason45";
        # GitHub "noreply" address: commits are linked to your account
        # without publishing your real e-mail.
        email = "340031061+reason45@users.noreply.github.com";
      };

      # New repositories start on `main` (matches GitHub's default).
      init.defaultBranch = "main";
      # First `git push` of a new branch just works (no --set-upstream dance).
      push.autoSetupRemote = true;
    };
  };
}
