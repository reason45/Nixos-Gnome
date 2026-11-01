# ── home/apps/packages.nix ──────────────────────────────────────────────────
# User apps. GNOME's own core apps (Nautilus, Papers, Loupe, Text Editor,
# Showtime, Decibels, Console) come from modules/desktop/gnome.nix; Firefox
# comes from modules/apps/firefox.nix.
#
# To install something: add its nixpkgs name here, then run `rebuild`.
# Find names with:  nix search nixpkgs <word>   or   https://search.nixos.org
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice # Writer / Calc / Impress (hidden entries: see app-settings.nix)
  ];
}
