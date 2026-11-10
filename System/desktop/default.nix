# ── System/desktop/default.nix ──────────────────────────────────────────────
# GNOME session. This folder is branch-owned: it is the only part of System/
# that differs between the gnome, kde and niri-noctalia branches.
{ ... }:
{
  imports = [
    ./gnome.nix # GDM + GNOME + removed apps
    ./ibus.nix # Nepali (Romanized/Traditional) typing
  ];
}
