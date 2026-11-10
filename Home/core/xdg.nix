# ── Home/core/xdg.nix ───────────────────────────────────────────────────────
# XDG user folders and the sidebar bookmarks of GTK file dialogs (Nautilus,
# Firefox and portal dialogs). "Open with" defaults differ per desktop and live
# in Home/desktop/.
{ config, lib, ... }:
let
  home = config.home.homeDirectory;

  # File-dialog sidebar bookmarks, in sidebar order. Declarative: the file is a
  # read-only link, so edit this list instead of adding bookmarks in the app.
  bookmarks = [
    { label = "Nixos";     path = "/etc/nixos"; }
    { label = "Desktop";   path = "${home}/Desktop"; }
    { label = "Documents"; path = "${home}/Documents"; }
    { label = "Downloads"; path = "${home}/Downloads"; }
    { label = "Music";     path = "${home}/Music"; }
    { label = "Pictures";  path = "${home}/Pictures"; }
    { label = "Videos";    path = "${home}/Videos"; }
  ];
in
{
  # Writes ~/.config/user-dirs.dirs (so apps and file dialogs know where
  # Downloads, Pictures, … are) and creates the folders.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    templates = null;    # no Templates / Public folders
    publicShare = null;
  };

  xdg.configFile."gtk-3.0/bookmarks".text =
    lib.concatMapStrings (b: "file://${b.path} ${b.label}\n") bookmarks;
}
