# ── Home/desktop/gnome/shell.nix ────────────────────────────────────────────
# GNOME Shell, sound, and privacy/housekeeping.

{ lib, ... }:

let
  g = lib.hm.gvariant;
in
{
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      always-show-log-out = true;

      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.TextEditor.desktop"
        "org.gnome.SystemMonitor.desktop"
      ];
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = false; #Value true when required
    };

    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-trash-files = true;
      remove-old-temp-files = true;
      old-files-age = g.mkUint32 5;
    };
  };
}
