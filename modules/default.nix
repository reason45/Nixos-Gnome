# ── modules/default.nix ─────────────────────────────────────────────────────
# Index of all shared SYSTEM modules (these run as root, system-wide).
# Per-user settings live in ../home instead.
#
# To disable a feature, comment out its line. To add one, create the file and
# list it here (remember `git add` — flakes only see tracked files).
{ ... }:
{
  imports = [
    # ── core: the basics every NixOS machine needs
    ./core/boot.nix # bootloader + quiet boot splash
    ./core/nix.nix # nix settings, garbage collection (nh), store optimise
    ./core/locale.nix # timezone, language, hardware clock
    ./core/users.nix # your login account
    ./core/home-manager.nix # plugs ../home in as the user's config
    ./core/networking.nix # NetworkManager (Wi-Fi etc.)
    ./core/packages.nix # tiny list of system-wide packages
    ./core/services.nix # printing, nix-ld, journal size cap

    # ── hardware: tuned for Dell Latitude 5410 (i5-10210U, 8 GB RAM)
    ./hardware/graphics.nix # Intel UHD graphics + video acceleration
    ./hardware/intel.nix # CPU microcode, firmware, thermald
    ./hardware/memory.nix # zram + swapfile + earlyoom
    ./hardware/audio.nix # PipeWire sound
    ./hardware/laptop.nix # battery, power profiles, Bluetooth, fwupd, TRIM

    # ── desktop: GNOME session
    ./desktop/fonts.nix # system fonts (incl. Nepali fonts)
    ./desktop/ibus.nix # Nepali (Romanized/Traditional) typing
    ./desktop/gnome.nix # GDM + GNOME + removed apps

    # ── system-wide apps
    ./apps/firefox.nix # Firefox + privacy policies + forced extensions
  ];
}
