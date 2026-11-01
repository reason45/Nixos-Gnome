# ── modules/core/boot.nix ───────────────────────────────────────────────────
# UEFI bootloader (systemd-boot) and a quiet, clean boot with a splash screen.
{ ... }:
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Disable editing kernel parameters at the boot menu (a basic security
      # measure: otherwise anyone at the keyboard could boot with init=/bin/sh).
      editor = false;
      # Keep only the 4 newest generations in the boot menu so the small
      # /boot (EFI) partition never fills up.
      configurationLimit = 4;
    };

    efi = {
      canTouchEfiVariables = true; # allow NixOS to register itself in UEFI
      efiSysMountPoint = "/boot"; # where the EFI partition is mounted
    };

    # Boot straight into the default entry. Hold Space (or tap a key) during
    # startup to get the menu; `rebuild-boot` generations stay selectable there.
    timeout = 0;
  };

  # Quiet graphical boot: Plymouth splash, no scrolling kernel/initrd output.
  boot.plymouth.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3; # only show errors on the console
  boot.kernelParams = [ "quiet" ]; # Plymouth adds "splash" itself
}
