# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  flake.nix — the ENTRY POINT of the whole configuration                  ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# A flake pins every input (nixpkgs, home-manager) to an exact revision in
# flake.lock, so the same config always builds the same system.
#
# Reading order for newcomers:
#   flake.nix  ->  configuration.nix  ->  System/default.nix
#                                     ->  Home/default.nix (via System/core/home-manager.nix)
#
# Daily commands (aliases are defined in home/shell/bash.nix):
#   rebuild        sudo nixos-rebuild switch --flake /etc/nixos
#   nix flake update   (run inside /etc/nixos) bump nixpkgs/home-manager, then rebuild
{
  description = "Sanzay's NixOS (GNOME) with integrated Home Manager — stable only";

  inputs = {
    # The package set + NixOS modules. "nixos-26.05" is a STABLE release
    # branch: it only gets security/bug fixes, no surprise major upgrades.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Home Manager manages everything in $HOME (shell, GNOME settings, ...).
    # The release branch MUST match the nixpkgs release (26.05 <-> 26.05).
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # Use OUR nixpkgs instead of downloading a second copy.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      # Single source of truth for the login name and the machine name; modules
      # receive them as `user` and `host` (see specialArgs below). Change them
      # here and they change everywhere.
      user = "sanzay";
      host = "latitude-5410";
    in
    {
      # The attribute name must equal networking.hostName (configuration.nix sets
      # it from `host`), so that `nixos-rebuild switch --flake .` picks this
      # machine automatically.
      #
      # Home Manager runs *as a NixOS module* (see System/core/home-manager.nix),
      # so ONE rebuild updates both the system and your user environment.
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        # Extra arguments handed to every module: `{ user, host, inputs, ... }:` works anywhere.
        specialArgs = { inherit inputs user host; };
        modules = [
          ./configuration.nix # machine entry (hardware + hostname + System/)
        ];
      };
    };
}
