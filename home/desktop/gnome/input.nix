# ── home/desktop/gnome/input.nix ────────────────────────────────────────────
# Touchpad, NumLock and keyboard layouts.
{ lib, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true; # tap = click
      natural-scroll = true; # two-finger scroll like a phone
      disable-while-typing = true; # palm protection
      send-events = "disabled-on-external-mouse"; # touchpad off when a USB mouse is plugged in
    };

    # NumLock on at login.
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
      remember-numlock-state = true;
    };

    # Keyboard layouts in the top-bar switcher: US + Nepali (ibus m17n).
    # Verify the engine name with `ibus list-engine`.
    # Switch with Super+Space.
    "org/gnome/desktop/input-sources".sources = [
      (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
      (lib.hm.gvariant.mkTuple [ "ibus" "m17n:ne:trad-ttf" ])
    ];

    # Focus-follows-mouse: the window under the pointer gets keyboard focus
    # without clicking ("sloppy" = focus stays when you move over the desktop).
    "org/gnome/desktop/wm/preferences".focus-mode = "sloppy";
  };
}
