# ── home/desktop/gnome/power.nix ────────────────────────────────────────────
# Idle, lock, suspend and night light.
{ lib, ... }:
{
  dconf.settings = {
    # Blank the screen after 300 s (5 min) without input.
    "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 300;

    "org/gnome/desktop/screensaver" = {
      lock-enabled = true; # require password after blanking
      lock-delay = lib.hm.gvariant.mkUint32 0; # lock the moment the screen blanks
    };

    "org/gnome/settings-daemon/plugins/power" = {
      # Suspend after 720 s (12 min) idle — same on AC and on battery.
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 720;
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 720;

      # GNOME dims the panel when idle and follows the ambient light sensor.
      # Both can look like a "permanently dim screen". Turn off to test.
      idle-dim = false;
      ambient-enabled = false;
    };

    # Warmer screen at night. Sunrise/sunset come from location services.
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };
  };
}
