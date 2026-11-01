# ── home/shell/bash.nix ─────────────────────────────────────────────────────
# Bash: aliases, history rules and the once-per-boot fastfetch banner.
# (The pretty prompt itself comes from starship.nix.)
{ ... }:
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
      # System + Home Manager in one go. The flake is /etc/nixos; the host
      # is picked by hostname (nixos).
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos"; # build + activate now
      rebuild-boot = "sudo nixos-rebuild boot --flake /etc/nixos"; # activate on next reboot
      rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos"; # activate, but don't make it the boot default
      rebuild-check = "nixos-rebuild build --flake /etc/nixos"; # build only, activate nothing

      # ── NixOS: cleanup ────────────────────────────────────────────────────
     # NORMAL: remove system generations older than 7 days, refresh the boot
      # menu, then collect garbage.
      clean = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations 7d && sudo nixos-rebuild boot --flake /etc/nixos && sudo nix-collect-garbage";

      # ATOM BOMB: delete EVERY old system generation, rebuild the boot entry,
      # wipe the Nix eval cache, then collect garbage. No rollback afterwards.
      clean-all = "sudo rm /nix/var/nix/profiles/system-* && sudo nixos-rebuild boot --flake /etc/nixos && sudo rm -rf ~/.cache/nix && sudo nix-collect-garbage -d";};

    # ── History ─────────────────────────────────────────────────────────────
    # No repeats, and trivial commands are never saved.
    historyControl = [ "ignoredups" "ignorespace" "erasedups" ]; # leading space = don't save
    historySize = 2000;
    historyFileSize = 2000;
    historyIgnore = [
      "ls" "ll" "cd" "cd *" "pwd" "clear" "exit" "reboot" "fastfetch"
      "history" "history *" "git status" "git add *" "free *" "df *"
    ];

    # Show fastfetch once per boot, in the first interactive shell.
    # (A marker file in the runtime dir is wiped at every reboot, which is
    # what makes it "once per boot".)
    initExtra = ''
      if [[ $- == *i* && -n "$XDG_RUNTIME_DIR" && ! -e "$XDG_RUNTIME_DIR/fastfetch-shown" ]]; then
        touch "$XDG_RUNTIME_DIR/fastfetch-shown"
        fastfetch
      fi
    '';
  };
}
