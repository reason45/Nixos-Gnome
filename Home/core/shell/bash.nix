# ── Home/core/shell/bash.nix ────────────────────────────────────────────────
# Bash: aliases, history rules and the fastfetch banner in every new terminal.
# (The pretty prompt itself comes from starship.nix.)
#
# `host` comes from flake.nix, so the aliases build the right machine even
# before the hostname has changed.
{ host, ... }:
let
  # Where the flake lives. Change this one line if you move it.
  flakeDir = "/etc/nixos";
  flake = "${flakeDir}#${host}";
in
{
  programs.bash = {
    enable = true;

    shellAliases = {
      # ── everyday ──────────────────────────────────────────────────────────
      ls = "ls --color=auto";
      ll = "ls -alFh --color=auto"; # long list, hidden files, human sizes
      la = "ls -A --color=auto"; # all files except . and ..
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";

      # ── NixOS: rebuild ────────────────────────────────────────────────────
      # System + Home Manager in one go. New files must be `git add`ed first
      # (flakes ignore untracked files).
      rebuild = "sudo nixos-rebuild switch --flake ${flake}"; # build + activate now
      rebuild-boot = "sudo nixos-rebuild boot --flake ${flake}"; # activate on next reboot
      rebuild-test = "sudo nixos-rebuild test --flake ${flake}"; # activate, but don't make it the boot default
      rebuild-check = "nixos-rebuild build --flake ${flake}"; # build only, activate nothing

      # ── NixOS: cleanup ────────────────────────────────────────────────────
      # NORMAL: remove system generations older than 7 days, refresh the boot
      # menu, then collect garbage.
      clean = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations 7d && sudo nixos-rebuild boot --flake ${flake} && sudo nix-collect-garbage";

      # ATOM BOMB: delete EVERY old system generation, rebuild the boot entry,
      # wipe the Nix eval cache, then collect garbage. No rollback afterwards.
      clean-all = "sudo rm /nix/var/nix/profiles/system-* && sudo nixos-rebuild boot --flake ${flake} && sudo rm -rf ~/.cache/nix && sudo nix-collect-garbage -d";
    };

    # ── History ─────────────────────────────────────────────────────────────
    # No repeats, and trivial commands are never saved.
    historyControl = [ "ignoredups" "ignorespace" "erasedups" ]; # leading space = don't save
    historySize = 2000;
    historyFileSize = 2000;
    historyIgnore = [
      "ls" "ll" "cd" "cd *" "pwd" "clear" "exit" "reboot" "fastfetch" "rebuild *"
      "history" "history *" "git *" "free *" "df *"
    ];

    # Show fastfetch every time an interactive shell starts (new terminal,
    # new tab, subshell). Scripts and other non-interactive shells skip it.
    initExtra = ''
      if [[ $- == *i* ]]; then
        fastfetch
      fi
    '';
  };

  # Default terminal editor (nano ships with NixOS).
  home.sessionVariables.EDITOR = "nano";
}
