# ── modules/core/networking.nix ─────────────────────────────────────────────
# Hostname lives in hosts/<machine>/default.nix.
{ ... }:
{
  # NetworkManager = Wi-Fi/Ethernet/VPN, and it powers GNOME's Wi-Fi menu.
  networking.networkmanager.enable = true;

  # The firewall is ON by default in NixOS (everything incoming is blocked).
  # To open a port, e.g. for a dev server or KDE Connect:
  #   networking.firewall.allowedTCPPorts = [ 3000 ];
}
