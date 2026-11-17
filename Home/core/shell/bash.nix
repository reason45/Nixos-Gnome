
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
      # Keep the latest 2 system generations, collect garbage, then rebuild the
      # boot menu so it no longer lists generations that were just deleted
      # (a stale entry would fail to boot).
      clean = ''
        sudo nix-env --profile /nix/var/nix/profiles/system \
          --delete-generations +2 &&
        sudo nix-collect-garbage &&
        sudo /run/current-system/bin/switch-to-configuration boot
      '';

      # ATOM BOMB 1 (clean-reinstall helper, e.g. switching desktop branches):
      # Delete system generation links, rebuild, wipe home and reboot.
      # PRESERVED in $HOME: Desktop Documents Downloads Pictures Public
      # Templates Music Projects Videos Filen .ssh and .config/mozilla.
      # Everything else (keyring, other dotfiles) is deleted on purpose.
      clean-all1 = ''
        sudo rm -rf -- /nix/var/nix/profiles/system-* &&
        sudo nixos-rebuild boot --flake ${flake} &&
        find "$HOME" -mindepth 1 -maxdepth 1 \
          ! -name Desktop \
          ! -name Documents \
          ! -name .ssh \
          ! -name Downloads \
          ! -name Pictures \
          ! -name Public \
          ! -name Templates \
          ! -name Music \
          ! -name Projects \
          ! -name Videos \
          ! -name Filen \
          ! -name .config \
          -exec rm -rf -- {} + &&
        find "$HOME/.config" -mindepth 1 -maxdepth 1 \
          ! -name mozilla \
          -exec rm -rf -- {} + &&
        sudo reboot
      '';

      # ATOM BOMB 2:
      # Garbage collect, optimize the store and reset GNOME settings.
      clean-all2 = ''
        sudo nix-collect-garbage -d &&
        sudo nix-store --optimise &&
        dconf reset -f /org/gnome/
      '';
    };

    # ── History ─────────────────────────────────────────────────────────────
    historyControl = [
      "ignoredups"
      "ignorespace"
      "erasedups"
    ];

    historySize = 2000;
    historyFileSize = 2000;

    # Ignore routine commands, aliases and selected Git operations.
    historyIgnore = [
      # Everyday commands
      "ls"
      "ll"
      "la"
      "grep"
      "cd"
      "cd *"
      "pwd"
      "clear"
      "exit"
      "reboot"
      "fastfetch"

      # Directory navigation aliases
      ".."
      "..."

      # NixOS aliases
      "rebuild"
      "rebuild-*"
      "clean"
      "clean-*"

      # Git: ignore only these operations.
      "git add*"
      "git push*"
      "git commit*"

      # Other routine commands
      "history"
      "history *"
      "free *"
      "df *"
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

