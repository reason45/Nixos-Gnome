# ── System/core/services.nix ───────────────────────────────────────────────
# Everyday system services that don't belong to a hardware/desktop module.
# (Added during the config review — each block can be deleted independently.)
{ ... }:
{
  # Printing (CUPS). GNOME Settings -> Printers can add printers and apps get a
  # working Print dialog. USB printers and printers added by IP address work
  # as-is. Avahi adds network-printer discovery; its firewall port stays closed
  # (no open ports). If a network printer is not discovered, set
  # openFirewall = true (opens UDP 5353 only).
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = false;
  };
  # Vendor drivers, only if a printer needs one (needs `pkgs` in the module
  # arguments): services.printing.drivers = [ pkgs.hplip ];  # HP

  # nix-ld: lets pre-built, NON-Nix Linux programs run (VS Code remote server,
  # pip/npm native wheels, downloaded CLI tools, AppImages, ...). Without it
  # they fail with "Could not start dynamically linked executable".
  programs.nix-ld.enable = true;

  # Cap the systemd journal (system logs) so it can't slowly eat the disk.
  # View logs with: journalctl -b   (this boot)   /   journalctl -p err -b
  services.journald.extraConfig = ''
    SystemMaxUse=200M
  '';

  # ── Ideas you may want later (uncomment to enable) ─────────────────────────
  # Flatpak (apps not packaged in nixpkgs; add flathub with
  #   flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo):
  # services.flatpak.enable = true;
}
