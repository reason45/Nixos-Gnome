# ── home/default.nix ────────────────────────────────────────────────────────
# Home Manager entry point, loaded by modules/core/home-manager.nix.
# username and home directory come from the system's users.users entry.
#
# Everything under ./home is PER-USER (dotfiles, GNOME settings, user apps).
# System-wide things (drivers, services, GDM) live in ../modules.
{ ... }:
{
  imports = [
    # ── shell: terminal experience
    ./shell/bash.nix # aliases, history, fastfetch on first terminal
    ./shell/starship.nix # the Powerline prompt
    ./shell/git.nix # git identity + defaults
    ./shell/fastfetch.nix # system-info banner
    ./shell/tools.nix # bat, fzf, ripgrep, fd, btop, direnv

    # ── apps
    ./apps/packages.nix # user apps (LibreOffice)
    ./apps/mimeapps.nix # "open with" defaults per file type

    # ── GNOME user session
    ./desktop/gnome/services.nix # random wallpaper + auto light/dark theme
    ./desktop/gnome/extensions.nix # Shell extensions
    ./desktop/gnome/input.nix # touchpad, NumLock, keyboard layouts
    ./desktop/gnome/power.nix # lock, suspend, night light
    ./desktop/gnome/keybinds.nix # keyboard shortcuts
    ./desktop/gnome/app-settings.nix # theme, fonts, dock, apps, weather
  ];

  # Like system.stateVersion: keep at the release you first used. Don't bump.
  home.stateVersion = "26.05";
}
