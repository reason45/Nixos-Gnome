# ── Home/desktop/gnome/appearance.nix ───────────────────────────────────────
# Theme packages, fonts, cursor, wallpapers.

{ config, lib, pkgs, ... }:

let
  g = lib.hm.gvariant;

  cursor = {
    name = "Bibata-Modern-Ice";
    size = 24;
  };
in
{
  home.packages = with pkgs; [
    orchis-theme
    tela-icon-theme
  ];

  home.sessionVariables = {
    XCURSOR_THEME = cursor.name;
    XCURSOR_SIZE = toString cursor.size;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "Inter 12";
      document-font-name = "Inter 12";
      monospace-font-name = "JetBrainsMono Nerd Font 12";

      cursor-theme = cursor.name;
      cursor-size = g.mkUint32 cursor.size;

      show-battery-percentage = true;
      enable-hot-corners = true;

      # Initial theme; Night Theme Switcher changes these at sunrise/sunset.
      gtk-theme = "Orchis-Light";
      icon-theme = "Tela";
      color-scheme = "prefer-light";
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Inter Bold 12";
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
    };
  };
}
