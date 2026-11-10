# ── Home/desktop/default.nix ────────────────────────────────────────────────
# GNOME user session. This folder is branch-owned: it is the only part of Home/
# that differs between the gnome, kde and niri-noctalia branches.
{ ... }:
{
  imports = [
    ./gnome/mimeapps.nix # "open with" defaults per file type
    ./gnome/services.nix # random wallpaper + auto light/dark theme
    ./gnome/extensions.nix # Shell extensions
    ./gnome/input.nix # touchpad, NumLock, keyboard layouts
    ./gnome/power.nix # lock, suspend, night light
    ./gnome/keybinds.nix # keyboard shortcuts
    ./gnome/appearance.nix # theme packages, fonts, cursor
    ./gnome/night-theme-switcher.nix # sunrise/sunset light-dark switching
    ./gnome/shell.nix # favorite apps, sound, privacy
    ./gnome/dash-to-dock.nix # dock transparency
    ./gnome/hidden-apps.nix # GNOME launcher entries to hide
    ./gnome/text-editor.nix # GNOME Text Editor
    ./gnome/weather.nix # Butwal location
  ];
}
