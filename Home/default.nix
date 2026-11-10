# ── Home/default.nix ────────────────────────────────────────────────────────
# Home Manager entry point, loaded by System/core/home-manager.nix.
# username and home directory come from the system's users.users entry.
#
# ./core is shared by every desktop branch (shell, common apps, xdg,
# wallpapers). ./desktop is branch-owned: it is the only part of Home/ that
# differs between the gnome, kde and niri-noctalia branches.
{ ... }:
{
  imports = [
    ./core
    ./desktop
  ];

  # Like system.stateVersion: keep at the release you first used. Don't bump.
  home.stateVersion = "26.05";
}
