# ── Home/desktop/gnome/hidden-apps.nix ──────────────────────────────────────
# GNOME-only launcher entries to hide. The mechanism (and the LibreOffice
# entries) is in Home/core/apps/hide-apps.nix.
{ ... }:
{
  hiddenApps = [
    "org.gnome.Characters" # Characters (character picker)
  ];
}
