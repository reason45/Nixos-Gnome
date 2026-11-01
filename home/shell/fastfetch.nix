# ── home/shell/fastfetch.nix ────────────────────────────────────────────────
# fastfetch: the system-info banner (shown once per boot, see bash.nix).
# Run `fastfetch` manually any time.
{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small"; # compact NixOS snowflake
        padding = { right = 2; };
      };
      display = {
        separator = "  ";
      };
      # Order = what is printed, top to bottom. Delete/reorder freely.
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "locale"
      ];
    };
  };
}
