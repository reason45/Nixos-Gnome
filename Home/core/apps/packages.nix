# ── Home/core/apps/packages.nix ─────────────────────────────────────────────
# User apps shared by every desktop. Desktop-specific apps live in
# Home/desktop/. Firefox and git are system-wide (System/apps/).
#
# To install something: add its nixpkgs name here, then run `rebuild`.
# Find names with:  nix search nixpkgs <word>   or   https://search.nixos.org
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice # Writer / Calc (the other entries are hidden: see hide-apps.nix)
    filen-desktop
  ];
}
