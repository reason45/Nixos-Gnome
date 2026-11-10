# ── Home/desktop/gnome/extensions.nix ───────────────────────────────────────
# GNOME Shell extensions, installed AND enabled declaratively by Home Manager
# (no need to click through the Extensions app / extensions.gnome.org).
# Their settings are in app-settings.nix.
#
# To add one: find it with `nix search nixpkgs gnomeExtensions.<name>`
# and add `{ package = <name>; }` below.
{ pkgs, ... }:

{
  programs.gnome-shell = {
    enable = true;

    extensions = with pkgs.gnomeExtensions; [
      { package = caffeine; } # top-bar cup: keep the screen awake (movies, presentations)
      { package = dash-to-dock; } # the transparent dock at the bottom
      { package = appindicator; } # tray icons for apps that still use them
      # Switches GTK/shell/icon themes at sunrise/sunset and runs commands.
      # Settings (day/night themes, commands) are in app-settings.nix.
      {
        package = night-theme-switcher;
        id = "nightthemeswitcher@romainvigier.fr";
      }

      # User Themes lets us theme GNOME Shell itself (Orchis). Its UUID is
      # given explicitly because it is not auto-detected from the package.
      {
        package = user-themes;
        id = "user-theme@gnome-shell-extensions.gcampax.github.com";
      }
    ];
  };
}
