# ── Home/core/shell/bash.nix ────────────────────────────────────────────────
# Bash: aliases, history rules and Fastfetch banner.
# The prompt itself is configured in starship.nix.

{ host, ... }:

let
  flakeDir = "/etc/nixos";
  flake = "${flakeDir}#${host}";
in
{
  programs.bash = {
    enable = true;

    # ── Aliases ─────────────────────────────────────────────────────────────
    shellAliases = {
      # Everyday
      ls = "ls --color=auto";
      ll = "ls -alFh --color=auto";
      la = "ls -A --color=auto";
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";

      # NixOS: rebuild
      rebuild       = "sudo nixos-rebuild switch --flake ${flake}";
      rebuild-boot  = "sudo nixos-rebuild boot --flake ${flake}";
      rebuild-test  = "sudo nixos-rebuild test --flake ${flake}";
      rebuild-check = "nixos-rebuild build --flake ${flake}";

      # NixOS: cleanup
      clean = "sudo nix-collect-garbage -d";

      reset-generation = ''
        sudo rm -rf -- /nix/var/nix/profiles/system-* &&
        sudo nixos-rebuild boot --flake ${flake}
      '';

      optimise = "sudo nix-store --optimise";
    };

    # ── History ─────────────────────────────────────────────────────────────
    historyControl = [
      "ignoredups"
      "ignorespace"
      "erasedups"
    ];

    # Unlimited history.
    historySize = -1;
    historyFileSize = -1;

    # Not stored in history: aliases and git commands.
    historyIgnore = [
      # Everyday aliases
      "ls"
      "ls *"
      "ll"
      "ll *"
      "la"
      "la *"
      "grep *"
      ".."
      "..."

      # NixOS aliases
      "rebuild"
      "rebuild-boot"
      "rebuild-test"
      "rebuild-check"
      "clean"
      "reset-generation"
      "optimise"

      # Git
      "git"
      "git *"
    ];

    # ── Fastfetch ───────────────────────────────────────────────────────────
    initExtra = ''
      if [[ $- == *i* ]]; then
        fastfetch
      fi
    '';
  };

  # ── Default editor ────────────────────────────────────────────────────────
  home.sessionVariables.EDITOR = "nano";
}
