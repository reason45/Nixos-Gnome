# ── System/core/networking.nix ──────────────────────────────────────────────
# NetworkManager for Wi-Fi and wired connections. The hostname is set in
# configuration.nix.
#
# Wi-Fi networks are saved by NetworkManager itself (nmcli or the desktop's
# network settings). Passwords are never stored in this repo.
#   nmcli device wifi connect "<SSID>" --ask
{ ... }:
{
  networking.networkmanager.enable = true;
}
