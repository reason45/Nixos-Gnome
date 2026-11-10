# ── System/default.nix ──────────────────────────────────────────────────────
# Index of all SYSTEM modules (these run as root, system-wide).
# Per-user settings live in ../Home instead.
#
# Everything here is shared by all desktop branches EXCEPT ./desktop, which is
# the only folder in System/ that differs per branch.
#
# To disable a feature, comment out its line. To add one, create the file and
# list it here (remember `git add` — flakes only see tracked files).
{ ... }:
{
  imports = [
    # ── core: the basics every NixOS machine needs
    ./core/boot.nix # bootloader (limine) + quiet boot splash
    ./core/nix.nix # nix settings, garbage collection (nh), store optimise
    ./core/locale.nix # timezone, language, hardware clock
    ./core/users.nix # your login account
    ./core/home-manager.nix # plugs ../Home in as the user's config
    ./core/networking.nix # NetworkManager (Wi-Fi etc.)
    ./core/services.nix # printing, nix-ld, journal size cap
    ./core/fonts.nix # system fonts (incl. Nepali fonts)

    # ── hardware: tuned for Dell Latitude 5410 (i5-10210U, 8 GB RAM)
    ./hardware/graphics.nix # Intel UHD graphics + video acceleration
    ./hardware/intel.nix # CPU microcode, firmware, thermald
    ./hardware/memory.nix # zram + swapfile + earlyoom
    ./hardware/audio.nix # PipeWire sound
    ./hardware/laptop.nix # battery, power profiles, Bluetooth, fwupd, TRIM

    # ── system-wide apps (kept here so they survive a Home Manager failure)
    ./apps/firefox.nix # Firefox + privacy policies + forced extensions
    ./apps/git.nix # git binary + identity + defaults

    # ── desktop session (branch-owned)
    ./desktop
  ];
}
