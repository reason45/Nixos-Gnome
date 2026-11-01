# ── modules/hardware/intel.nix ──────────────────────────────────────────────
# Intel CPU + firmware (Latitude 5410, i5 10th gen Comet Lake).
# On an AMD machine, swap this file for an amd.nix with
# hardware.cpu.amd.updateMicrocode = true; and drop thermald.
{ ... }:
{
  # Closed-source firmware blobs that the hardware needs to work properly.
  hardware.enableRedistributableFirmware = true; # microcode + i915/Wi-Fi/Bluetooth firmware
  hardware.cpu.intel.updateMicrocode = true; # CPU security/bug-fix microcode
  services.thermald.enable = true; # Intel thermal daemon: prevents overheating/throttling
}
