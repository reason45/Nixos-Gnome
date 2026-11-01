# ── home/desktop/gnome/keybinds.nix ─────────────────────────────────────────
# Preferred shortcuts.
#
#   Super+T            open terminal (GNOME Console)
#   Super+B            open Firefox
#   Shift+Super+T      toggle dark / light mode
#   Super+Q  /Alt+F4   close window
#   Super+F            maximize / restore
#   Shift+Super+F      fullscreen
#   Shift+Super+S/Print  screenshot UI
{ lib, pkgs, ... }:
let
  # GNOME stores custom shortcuts under this dconf path, one "slot" each.
  base = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings";

  # Small script behind Shift+Super+T: flips GNOME between light and dark.
  # (themes then follow automatically via services.nix)
  toggleColorScheme = pkgs.writeShellScript "toggle-color-scheme" ''
    dconf=${pkgs.dconf}/bin/dconf
    key=/org/gnome/desktop/interface/color-scheme
    case "$($dconf read $key)" in
      *dark*) $dconf write $key "'prefer-light'" ;;
      *)      $dconf write $key "'prefer-dark'" ;;
    esac
  '';

  # Add a line here to add a shortcut; slots are numbered automatically.
  custom = [
    { name = "Terminal"; command = "kgx"; binding = "<Super>t"; }
    { name = "Browser"; command = "firefox"; binding = "<Super>b"; }
    { name = "Toggle dark/light"; command = toString toggleColorScheme; binding = "<Shift><Super>t"; }
  ];

  slot = i: "custom${toString i}";
in
{
  dconf.settings = {
    # Register the custom slots (custom0, custom1, ...).
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings =
      lib.imap0 (i: _: "/${base}/${slot i}/") custom;

    # Built-in window-manager shortcuts we re-map.
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" "<Alt>F4" ];
      toggle-maximized = [ "<Super>f" ];
      toggle-fullscreen = [ "<Shift><Super>f" ];
    };

    "org/gnome/shell/keybindings".show-screenshot-ui = [ "<Shift><Super>s" "Print" ];
  }
  # Fill in each slot's name/command/binding from the `custom` list above.
  // lib.listToAttrs (lib.imap0 (i: kb: lib.nameValuePair "${base}/${slot i}" kb) custom);
}
