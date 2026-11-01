# ── home/shell/git.nix ──────────────────────────────────────────────────────
# Git identity and sensible defaults.
{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sanjayawosti";
        # GitHub "noreply" address: commits are linked to your account
        # without publishing your real e-mail.
        email = "340031061+sanjayawosti@users.noreply.github.com";
      };

      # New repositories start on `main` (matches GitHub's default).
      init.defaultBranch = "main";
      # First `git push` of a new branch just works (no --set-upstream dance).
      push.autoSetupRemote = true;
    };
  };
}
