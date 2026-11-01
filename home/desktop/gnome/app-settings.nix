# ── home/desktop/gnome/app-settings.nix ─────────────────────────────────────
# GNOME application and desktop settings: theme, fonts, cursor, wallpapers,
# dock, hidden apps, text editor, weather, Files bookmarks, housekeeping.
#
# `dconf.settings` = the same thing as toggling options in GNOME Settings, but
# declarative. To discover a key: run `dconf watch /` and change the setting
# in the GUI — the path and value are printed.
{ config, lib, pkgs, ... }:

let
  g = lib.hm.gvariant; # helpers for GNOME's typed values (uint32, tuples, ...)
  home = "file://${config.home.homeDirectory}";

  # One place for the cursor, reused below. (Keep in sync with
  # modules/desktop/gnome.nix, which sets the same cursor for the login screen.)
  cursor = {
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Weather location: Butwal, Nepal. (The numbers are latitude/longitude in
  # RADIANS — copy the value GNOME Weather writes if you change the city:
  # `dconf read /org/gnome/Weather/locations`.)
  butwal = g.mkVariant (
    g.mkTuple [
      (g.mkUint32 2)
      (g.mkVariant (
        g.mkTuple [
          "Butwal"
          ""
          false
          [ (g.mkTuple [ 0.48346667477794125 1.4564493355212362 ]) ]
          (g.mkEmptyArray (g.type.tupleOf [
            g.type.double
            g.type.double
          ]))
        ]
      ))
    ]
  );
in
{
  # ── Appearance packages ───────────────────────────────────────────────────
  home.packages = with pkgs; [
    orchis-theme # GTK + GNOME Shell theme (Light/Dark variants)
    tela-icon-theme # icon theme (Tela / Tela-dark)
  ];
  # (The active theme names are set by services.nix, which swaps
  #  Orchis-Dark/Light + Tela whenever dark/light mode changes.)

  # Cursor for apps that read environment variables (X11/Xwayland).
  home.sessionVariables = {
    XCURSOR_THEME = cursor.name;
    XCURSOR_SIZE = toString cursor.size;
  };

  # ── Wallpapers ────────────────────────────────────────────────────────────
  # Wallpaper images are supplied by the repository's ../../../Assets/wallpapers folder.
  # Home Manager links it to ~/Pictures/Wallpapers; drop more images into
  # Assets/wallpapers/ (and `git add` them) to add to the rotation.
  home.file."Pictures/Wallpapers" = {
    source = ../../../Assets/wallpapers;
    recursive = true;
  };

  dconf.settings = {
    # ── GNOME interface ─────────────────────────────────────────────────────
    "org/gnome/desktop/interface" = {
      font-name = "Inter 12"; # UI font
      document-font-name = "Inter 12";
      monospace-font-name = "JetBrainsMono Nerd Font 12"; # terminal/code font
      cursor-theme = cursor.name;
      cursor-size = g.mkUint32 cursor.size;
      show-battery-percentage = true; # "48%" next to the battery icon
      enable-hot-corners = false; # no accidental Overview when the mouse hits the corner
    };

    "org/gnome/desktop/wm/preferences".titlebar-font = "Inter Bold 12";

    # Volume slider stops at 100% (no distorted over-amplification).
    "org/gnome/desktop/sound".allow-volume-above-100-percent = false;

    # Wallpaper display behavior.
    # The actual image is selected by services.nix.
    "org/gnome/desktop/background".picture-options = "zoom";

    # ── Privacy / housekeeping (added during review) ────────────────────────
    # Empty the Trash and temp files automatically after 30 days.
    "org/gnome/desktop/privacy" = {
      remove-old-trash-files = true;
      remove-old-temp-files = true;
      old-files-age = g.mkUint32 30;
    };

    # ── GNOME Shell ─────────────────────────────────────────────────────────
    "org/gnome/shell" = {
      disable-user-extensions = false; # extensions allowed (see extensions.nix)
      always-show-log-out = true; # Log Out item always visible in the power menu

      # Pinned apps in the dock, in order.
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.TextEditor.desktop"
        "org.gnome.SystemMonitor.desktop"
      ];
    };

    # ── Dash to Dock ────────────────────────────────────────────────────────
    "org/gnome/shell/extensions/dash-to-dock" = {
      transparency-mode = "FIXED"; # fixed opacity instead of adaptive
      background-opacity = 0.3; # 30% — the glassy dock in the screenshots
      show-trash = false; # no Trash icon in the dock
    };

    # ── App Hider ───────────────────────────────────────────────────────────
    # Launchers hidden from the app grid/search to keep it tidy.
    # (The apps stay installed — remove a line to show it again.)
    "org/gnome/shell/extensions/app-hider" = {
      hidden-apps = [
        "math.desktop" # LibreOffice Math
        "impress.desktop" # LibreOffice Impress
        "draw.desktop" # LibreOffice Draw
        "base.desktop" # LibreOffice Base
        "startcenter.desktop" # LibreOffice Start Center
        "org.gnome.Characters.desktop"
      ];
    };

    # ── GNOME Text Editor ───────────────────────────────────────────────────
    "org/gnome/TextEditor" = {
      show-line-numbers = true;
      highlight-current-line = true;
      auto-indent = true;
      restore-session = false; # start with a clean document each time
    };

    # ── GNOME Weather ───────────────────────────────────────────────────────
    "org/gnome/Weather".locations = [ butwal ];

    "org/gnome/shell/weather" = {
      automatic-location = false; # fixed city instead of GPS/IP guess
      locations = [ butwal ];
    };
  };

  # ── Files (Nautilus) sidebar bookmarks ────────────────────────────────────
  # Format: "<uri> <optional label>" per line.
  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///etc/nixos Nixos
    ${home}/Desktop
    ${home}/Documents
    ${home}/Music
    ${home}/Pictures
    ${home}/Videos
    ${home}/Downloads
  '';
}
