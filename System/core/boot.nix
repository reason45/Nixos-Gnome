# ── System/core/boot.nix ───────────────────────────────────────────────────
# UEFI bootloader (limine) and a quiet, clean boot with a splash screen.
{ ... }:
{
  boot.loader = {
    systemd-boot.enable = false;
 
    limine = {
      enable = true;
      maxGenerations = 4;
      style.wallpapers = [ ];
      extraConfig = "quiet";
    
    };

    efi = {
      canTouchEfiVariables = true; # allow NixOS to register itself in UEFI
      efiSysMountPoint = "/boot"; # where the EFI partition is mounted
    };

    #Set bootloader timeout
    timeout = 3;
  };

  # Quiet graphical boot: Plymouth splash, no scrolling kernel/initrd output.
  boot.plymouth.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3; # only show errors on the console
  boot.kernelParams = [ "quiet" ]; # Plymouth adds "splash" itself
}
