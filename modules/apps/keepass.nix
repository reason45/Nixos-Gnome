# ── modules/apps/keepassxc.nix ──────────────────────────────────────────────
# KeePassXC: native Wayland (fixes the tiny cursor), autostart at login.
{ pkgs, ... }:
let
  keepassxc = pkgs.symlinkJoin {
    name = "keepassxc";
    paths = [ pkgs.keepassxc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/keepassxc --set QT_QPA_PLATFORM wayland
    '';
  };
in
{
  environment.systemPackages = [ keepassxc ];

  # Start at login (works on desktops that honour XDG autostart, e.g. GNOME, KDE).
  environment.etc."xdg/autostart/org.keepassxc.KeePassXC.desktop".source =
    "${keepassxc}/share/applications/org.keepassxc.KeePassXC.desktop";
}
