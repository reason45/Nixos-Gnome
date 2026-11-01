# ── modules/core/locale.nix ─────────────────────────────────────────────────
# Time zone, language and clock behaviour.
{ ... }:
{
  time.timeZone = "Asia/Kathmandu"; # Nepal Time (UTC+05:45)
  i18n.defaultLocale = "en_US.UTF-8"; # system language/format (English)

  # Windows stores the hardware clock in LOCAL time, Linux in UTC. With
  # dual-boot, make Linux follow Windows so the time isn't off by hours
  # after switching OS. Remove this line if you don't dual-boot.
  time.hardwareClockInLocalTime = true;
}
