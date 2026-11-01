# ── modules/desktop/ibus.nix ────────────────────────────────────────────────
# Nepali typing. ibus for GNOME (Wayland/X11); the Nepali fonts are in fonts.nix.
#
# Switch between English and Nepali with Super+Space (GNOME default), or via
# the language indicator in the top bar. Layouts are listed in
# home/desktop/gnome/input.nix.
{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n ]; # m17n provides Nepali (ne)
  };

  # Preload engines for every user. Check exact names with `ibus list-engine`
  # and adjust (unknown names are ignored).
  programs.dconf.profiles.user.databases = [
    {
      settings."desktop/ibus/general".preload-engines = [
        "xkb:us::eng" # plain US English keyboard
        "m17n:ne:trad-ttf" # Nepali (traditional layout)
      ];
    }
  ];
}
