# ── Home/core/default.nix ───────────────────────────────────────────────────
# Per-user config shared by every desktop. Identical on all branches.
{ ... }:
{
  imports = [
    # ── shell: terminal experience
    ./shell/bash.nix # aliases, history, fastfetch in every new terminal
    ./shell/starship.nix # the prompt (Nerd Font symbols preset)
    ./shell/fastfetch.nix # system-info banner

    # ── apps
    ./apps/packages.nix # user apps (LibreOffice)
    ./apps/hide-apps.nix # hide launcher entries (works on any desktop)

    # ── files and folders
    ./xdg.nix # user folders + file-dialog bookmarks
    ./wallpapers.nix # Assets/wallpapers -> ~/Pictures/Wallpapers
  ];
}
