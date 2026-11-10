# ── Home/desktop/gnome/services.nix ─────────────────────────────────────────
# User services (systemd --user): random wallpaper rotation. Inspect with:
#   systemctl --user list-timers          (shows the next wallpaper change)
#   journalctl --user -u random-wallpaper (logs if the wallpaper doesn't change)
#
# Dark/light theme switching is handled by the Night Theme Switcher extension
# (see extensions.nix and app-settings.nix).
{ config, pkgs, ... }:

let
  # Folder filled by Home/core/wallpapers.nix from Assets/wallpapers.
  wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";

  # ── Script: pick a random wallpaper ───────────────────────────────────────
  # (Plain bash. Inside this Nix string, a literal bash `${` is written
  # `''${` — that is a Nix escape, not a typo.)
  randomWallpaper = pkgs.writeShellScript "random-wallpaper" ''
    set -euo pipefail

    wallpaper_dir="${wallpaperDir}"

    # Collect every image in the folder. -L follows the symlinks that
    # Home Manager creates for the files.
    mapfile -t images < <(
      ${pkgs.findutils}/bin/find -L "$wallpaper_dir" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) \
        -print
    )

    if [ "''${#images[@]}" -eq 0 ]; then
      echo "No wallpapers found in $wallpaper_dir"
      exit 1
    fi

    # Avoid selecting the currently active wallpaper again if possible.
    # gsettings prints the value wrapped in single quotes ('file:///...'),
    # so strip them before comparing.
    current="$(${pkgs.glib}/bin/gsettings get \
      org.gnome.desktop.background picture-uri | ${pkgs.coreutils}/bin/tr -d "'")"

    candidates=()

    for image in "''${images[@]}"; do
      uri="$(${pkgs.python3}/bin/python3 -c \
        'import pathlib, sys; print(pathlib.Path(sys.argv[1]).as_uri())' \
        "$image")"

      if [ "$uri" != "$current" ]; then
        candidates+=("$image")
      fi
    done

    # Only switch to the filtered list if something is left
    # (with a single wallpaper we have to reuse it).
    if [ "''${#candidates[@]}" -gt 0 ]; then
      images=("''${candidates[@]}")
    fi

    # Pick a random index.
    index=$(${pkgs.coreutils}/bin/shuf \
      -i 0-$((''${#images[@]} - 1)) -n 1)

    selected="''${images[$index]}"

    uri="$(${pkgs.python3}/bin/python3 -c \
      'import pathlib, sys; print(pathlib.Path(sys.argv[1]).as_uri())' \
      "$selected")"

    # JSON strings are compatible with GVariant string syntax.
    quoted_uri="$(${pkgs.python3}/bin/python3 -c \
      'import json, sys; print(json.dumps(sys.argv[1]))' "$uri")"

    # GNOME has two keys: one for the light theme, one for the dark theme.
    # Set both so the wallpaper stays the same when you toggle dark/light.
    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.background picture-uri "$quoted_uri"

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.background picture-uri-dark "$quoted_uri"
  '';
in
{
  systemd.user.services = {
    # One-shot job: select and apply a random wallpaper (triggered by the
    # timer below).
    random-wallpaper = {
      Unit = {
        Description = "Choose a random GNOME wallpaper";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${randomWallpaper}";
      };
    };
  };

  # Run once at session startup, then every four minutes.
  # Change "4min" to e.g. "30min" or "1h" for a calmer desktop.
  systemd.user.timers.random-wallpaper = {
    Unit.Description = "Change GNOME wallpaper every four minutes";

    Timer = {
      OnStartupSec = "0";
      OnUnitActiveSec = "4min";
      Unit = "random-wallpaper.service";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
