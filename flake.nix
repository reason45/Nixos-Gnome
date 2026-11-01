# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  flake.nix — the ENTRY POINT of the whole configuration                  ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# A flake pins every input (nixpkgs, home-manager) to an exact revision in
# flake.lock, so the same config always builds the same system.
#
# Reading order for newcomers:
#   flake.nix  ->  hosts/latitude-5410/default.nix  ->  modules/default.nix
#                                                   ->  home/default.nix
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

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Single source of truth for the login name; modules receive it as `user`
      # (see specialArgs below). Change it here and it changes everywhere.
      user = "sanzay";
    in
    {
      # The attribute name ("nixos") must equal networking.hostName, so that
      # `nixos-rebuild switch --flake .` picks this machine automatically.
      #
      # Home Manager runs *as a NixOS module* (see modules/core/home-manager.nix),
      # so ONE rebuild updates both the system and your user environment.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        # Extra arguments handed to every module: `{ user, ... }:` works anywhere.
        specialArgs = { inherit user; };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/latitude-5410 # machine-specific entry (hardware + hostname)
        ];
      };
    };
}
