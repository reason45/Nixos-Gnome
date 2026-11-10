# ── Home/desktop/gnome/night-theme-switcher.nix ─────────────────────────────
# Night Theme Switcher v82 + User Themes extension.
#   Sunrise: Orchis-Light + Tela
#   Sunset:  Orchis-Dark  + Tela-dark

{ lib, pkgs, ... }:

let
  g = lib.hm.gvariant;

  nts = "org/gnome/shell/extensions/nightthemeswitcher";

  # GNOME Shell User Themes schema.
  userTheme = "org/gnome/shell/extensions/user-theme";

  onSunrise = pkgs.writeShellScript "on-sunrise" ''
    set -e

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.interface gtk-theme 'Orchis-Light'

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.interface icon-theme 'Tela'

    ${pkgs.dconf}/bin/dconf write \
      /${userTheme}/name "'Orchis-Light'"

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.interface color-scheme 'prefer-light'

    ${pkgs.libnotify}/bin/notify-send \
      "Sunrise" "Orchis Light theme enabled"
  '';

  onSunset = pkgs.writeShellScript "on-sunset" ''
    set -e

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.interface gtk-theme 'Orchis-Dark'

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.interface icon-theme 'Tela-dark'

    ${pkgs.dconf}/bin/dconf write \
      /${userTheme}/name "'Orchis-Dark'"

    ${pkgs.glib}/bin/gsettings set \
      org.gnome.desktop.interface color-scheme 'prefer-dark'

    ${pkgs.libnotify}/bin/notify-send \
      "Sunset" "Orchis Dark theme enabled"
  '';
in
{
  dconf.settings = {
    # Requires user-theme@gnome-shell-extensions.gcampax.github.com.
    "${userTheme}" = {
      name = "Orchis-Light";
    };

    # Location is inside the TIME schema in version 82.
    # Coordinates are decimal degrees: latitude, longitude.
    "${nts}/time" = {
      manual-schedule = false;

      location = g.mkTuple [
        28.048561867461615
        81.6167
      ];
    };

    "${nts}/color-scheme" = {
      day = "prefer-light";
      night = "prefer-dark";
    };

    "${nts}/commands" = {
      enabled = true;
      sunrise = "${onSunrise}";
      sunset = "${onSunset}";
    };
  };
}
