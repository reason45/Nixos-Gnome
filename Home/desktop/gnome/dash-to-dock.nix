# ── Home/desktop/gnome/dash-to-dock.nix ─────────────────────────────────────

{ ... }:

{
  dconf.settings."org/gnome/shell/extensions/dash-to-dock" = {
    transparency-mode = "FIXED";
    background-opacity = 0.3;
    show-trash = false;
  };
}
