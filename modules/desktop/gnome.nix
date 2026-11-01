# ── modules/desktop/gnome.nix ───────────────────────────────────────────────
# GNOME session + GDM. User-level GNOME settings live in home/desktop/gnome/.
{ pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = true; # graphical login screen (Wayland)
  services.desktopManager.gnome.enable = true; # the GNOME desktop itself

  # Core apps we don't want. Showtime (video) and Decibels (audio) stay.
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour # first-login tour
    gnome-user-docs # help manual
    epiphany # GNOME Web — Firefox is the browser
    gnome-contacts
    gnome-logs
    gnome-connections # remote desktop client
    baobab # Disk Usage Analyzer
    gnome-maps
    yelp # help viewer
  ];

  environment.systemPackages = with pkgs; [
    file-roller # archive handler (not part of GNOME's core-app set)
    bibata-cursors # system-wide so both GDM and the user session can use it
  ];

  # Login-screen cursor: GDM can't see the user's settings.
  # (Keep in sync with the cursor in home/desktop/gnome/app-settings.nix.)
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        cursor-theme = "Bibata-Modern-Ice";
        cursor-size = lib.gvariant.mkUint32 24;
      };
    }
  ];
}
