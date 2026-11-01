# ── modules/core/nix.nix ────────────────────────────────────────────────────
# How Nix itself behaves: unfree packages, build limits, cleanup, store size.
{ ... }:
{
  # Allow proprietary software (Chrome, fonts, firmware...). Because Home
  # Manager uses the global pkgs, this also covers your user packages.
  nixpkgs.config.allowUnfree = true;

  # Skip building the local NixOS manual (saves build time and disk).
  # Read the docs online at https://nixos.org/manual instead.
  documentation.nixos.enable = false;

  nix.settings = {
    # `nix ...` commands and flakes are still "experimental" flags in Nix,
    # but this whole config depends on them.
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false; # hide "git tree is dirty" warnings

    # Keep big rebuilds from running out of memory on an 8 GB machine.
    cores = 4; # CPU threads per build job
    max-jobs = 2; # parallel build jobs
  };

  # Run the Nix daemon at idle priority so rebuilds don't make the desktop lag.
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  # Keeps generations from the last 7 days
    nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Deduplicate identical files in the store (saves disk, not RAM).
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
