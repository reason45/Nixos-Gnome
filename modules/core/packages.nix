# ── modules/core/packages.nix ───────────────────────────────────────────────
# System-wide basics only. Apps you use yourself belong in home/apps/packages.nix.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git # needed to build the flake in /etc/nixos
  ];
}
