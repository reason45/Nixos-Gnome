# ── System/core/nix.nix ────────────────────────────────────────────────────
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

    # Disk-space safety: if free space on the store's disk drops below
    # min-free during a build, Nix garbage-collects UNREFERENCED paths until
    # max-free is available. It never deletes generations, so rollbacks stay.
    min-free = 2 * 1024 * 1024 * 1024; # 2 GiB
    max-free = 6 * 1024 * 1024 * 1024; # 6 GiB
  };

  # Run the Nix daemon at idle priority so rebuilds don't make the desktop lag.
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  # Weekly garbage collection. Generations older than 21 days are deleted.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
  };

  # After every GC, rebuild the boot menu. Otherwise the bootloader keeps
  # listing generations that GC just deleted, and picking one fails to boot.
  systemd.services.nix-gc.serviceConfig.ExecStartPost =
    "/run/current-system/bin/switch-to-configuration boot";

  # Deduplicate identical files in the store (saves disk, not RAM).
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
