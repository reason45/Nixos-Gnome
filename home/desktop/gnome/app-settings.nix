# ── home/desktop/gnome/app-settings.nix ─────────────────────────────────────
# GNOME application and desktop settings: theme, fonts, cursor, wallpapers,
# dock, hidden apps, text editor, weather, Files bookmarks, housekeeping,
# and Night Theme Switcher (day/night themes + sunrise/sunset commands).
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

  # ── Night Theme Switcher ──────────────────────────────────────────────────
  # Base dconf path of the extension (key names: verify with
  # `dconf dump /org/gnome/shell/extensions/nightthemeswitcher/`).
  nts = "org/gnome/shell/extensions/nightthemeswitcher";

  # Commands run by the extension at sunrise / sunset. Store paths are used
  # because the extension's shell does not have your NixOS PATH.
  onSunrise = pkgs.writeShellScript "on-sunrise" ''
    ${pkgs.libnotify}/bin/notify-send "Sunrise" "Light mode"
  '';
  onSunset = pkgs.writeShellScript "on-sunset" ''
    ${pkgs.libnotify}/bin/notify-send "Sunset" "Dark mode"
  '';
in
{
  # ── Appearance packages ───────────────────────────────────────────────────
  home.packages = with pkgs; [
    orchis-theme # GTK + GNOME Shell theme (Light/Dark variants)
    tela-icon-theme # icon theme (Tela / Tela-dark)
  ];
  # (Day/night theme names are set below by Night Theme Switcher; the
  #  extension itself is installed and enabled in extensions.nix.)

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
      enable-hot-corners = true; # moving the mouse to the top-left corner opens the Overview
    };

    "org/gnome/desktop/wm/preferences".titlebar-font = "Inter Bold 12";

    # Volume slider may go above 100% (amplified, can distort).
    "org/gnome/desktop/sound".allow-volume-above-100-percent = true;

    # Wallpaper display behavior.
    # The actual image is selected by the random-wallpaper timer in services.nix.
    "org/gnome/desktop/background".picture-options = "zoom";

    # ── Privacy / housekeeping (added during review) ────────────────────────
    # Empty the Trash and temp files automatically after 5 days.
    # Disable Nautilus recent-file history.
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-trash-files = true;
      remove-old-temp-files = true;
      old-files-age = g.mkUint32 5;
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

    # ── Night Theme Switcher ────────────────────────────────────────────────
    # Day = light mode (sunrise → sunset), night = dark mode.
    # Background switching is intentionally left off so it doesn't fight the
    # random-wallpaper timer in services.nix.
    # Automatic schedule: the extension computes sunrise/sunset itself from
    # this location (degrees: latitude, longitude). The sunrise/sunset values
    # in dconf are calculated results, so they are not declared here.
    "${nts}/time" = {
      manual-schedule = false;
      location = g.mkTuple [ 28.048561867461615 81.6167 ];
    };

    "${nts}/gtk-variants" = {
      enabled = true;
      day = "Orchis-Light";
      night = "Orchis-Dark";
    };
    "${nts}/shell-variants" = {
      enabled = true;
      day = "Orchis-Light";
      night = "Orchis-Dark";
    };
    "${nts}/icon-variants" = {
      enabled = true;
      day = "Tela";
      night = "Tela-dark";
    };
    "${nts}/commands" = {
      enabled = true;
      sunrise = "${onSunrise}";
      sunset = "${onSunset}";
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
