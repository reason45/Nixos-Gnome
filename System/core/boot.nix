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

      # Windows lives on a separate ESP (sda1), so chainload it by PARTUUID.
      extraEntries = ''
        /Windows
            protocol: efi
            path: guid(207a00fd-ee89-4e89-99e4-f5e65221d6ed):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

    efi = {
      canTouchEfiVariables = true; # allow NixOS to register itself in UEFI
      efiSysMountPoint = "/boot"; # where the EFI partition is mounted
    };

    # Set bootloader timeout
    timeout = 3;
  };

  # Quiet graphical boot: Plymouth splash, no scrolling kernel/initrd output.
  boot.plymouth.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3; # only show errors on the console
  boot.kernelParams = [ "quiet" ]; # Plymouth adds "splash" itself
}
