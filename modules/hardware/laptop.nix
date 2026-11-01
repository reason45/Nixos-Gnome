# ── modules/hardware/laptop.nix ─────────────────────────────────────────────
# Laptop services: battery, power profiles, Bluetooth, firmware updates, SSD TRIM.
# Power profiles show up in GNOME's quick-settings power menu.
{ ... }:
{
  services.upower.enable = true; # battery level/percentage for GNOME
  services.power-profiles-daemon.enable = true; # Power Saver / Balanced / Performance toggle
  hardware.bluetooth.enable = true; # Bluetooth (GNOME's Bluetooth tile)
  services.fwupd.enable = true; # Dell BIOS/firmware updates: fwupdmgr update
  services.fstrim.enable = true; # weekly TRIM for the SSD
}
