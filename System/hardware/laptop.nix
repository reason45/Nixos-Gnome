# ── System/hardware/laptop.nix ─────────────────────────────────────────────
# Laptop services: battery, power profiles, Bluetooth, firmware updates,
# SSD TRIM and SSD health (SMART).
# Power profiles show up in GNOME's quick-settings power menu.
{ ... }:
{
  # Battery level/percentage for GNOME, plus the low-battery policy.
  # No hibernate/resume swap is configured, so the default hibernate-style
  # critical action could not safely resume. PowerOff shuts down cleanly
  # instead of letting the battery run flat. Order must stay Low > Critical > Action.
  services.upower = {
    enable = true;
    percentageLow = 15; # "low battery" warning
    percentageCritical = 7; # "critical" warning
    percentageAction = 4; # clean shutdown here
    criticalPowerAction = "PowerOff";
  };

  services.power-profiles-daemon.enable = true; # Power Saver / Balanced / Performance toggle
  hardware.bluetooth.enable = true; # Bluetooth (GNOME's Bluetooth tile)
  services.fwupd.enable = true; # Dell BIOS/firmware updates: fwupdmgr update
  services.fstrim.enable = true; # weekly TRIM for the SSD

  # SMART monitoring: watches the SSD and warns before it fails.
  # Warnings are also logged:  journalctl -u smartd
  # Quick check:  sudo smartctl -H /dev/sda   (find the device name with `lsblk`)
  services.smartd = {
    enable = true;
    # Desktop pop-ups via systembus-notify. This must be true: earlyoom (see
    # hardware/memory.nix) already enables systembus-notify, and smartd defaults it to
    # false, which makes the two modules conflict.
    notifications.systembus-notify.enable = true;
  };
}
