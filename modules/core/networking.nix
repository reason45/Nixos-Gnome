
# ── modules/core/networking.nix ─────────────────────────────────────────────
# Hostname lives in hosts/<machine>/default.nix.
{ ... }:
{
  # NetworkManager = Wi-Fi/Ethernet/VPN, and it powers GNOME's Wi-Fi menu.
  networking.networkmanager = {
    enable = true;

    # Declaratively manage saved Wi-Fi connections.
    ensureProfiles.profiles = {
      home-wifi = {
        connection = {
          id = "Wifi";
          type = "wifi";
          autoconnect = true;
        };

        wifi = {
          mode = "infrastructure";
          ssid = "Wifi";
        };

        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "5a13f9317d56cc29ddcdb3377edc59f12d22b82c86e68b14d91293bde29fdff8";
        };

        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };
  };

   # The firewall is ON by default in NixOS (everything incoming is blocked).
  # Ports 1714-1764 are for GSConnect / KDE Connect.
  networking.firewall = {
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
  };
}

