# ── Home/core/apps/hide-apps.nix ────────────────────────────────────────────
# Hide launcher entries you never use. Plain XDG desktop entries installed at
# user level, so it works the same on every desktop.
#
# Two kinds:
#
#  1. hiddenApps (option) — every ID listed gets a stub with `Hidden=true`, so
#     the entry is ignored completely. Each desktop adds its own IDs, e.g.
#       hiddenApps = [ "org.gnome.Characters" ];
#     Only for things never opened or used as a handler.
#  2. LibreOffice sub-apps — copies of the REAL entries with `NoDisplay=true`:
#     gone from the launcher, but still usable as a default handler (impress is
#     the .pptx handler, so it must keep its Exec).
#
# IMPORTANT: LibreOffice itself is installed in apps/packages.nix. Do not add
# libreofficeNoDisplay to home.packages: it creates duplicate desktop files and
# causes a buildEnv collision.
{ pkgs, lib, config, ... }:

let
  # ── 1. fully hidden stubs (IDs come from the hiddenApps option) ───────────
  stubs = pkgs.runCommand "hidden-desktop-entries" { } ''
    mkdir -p "$out/share/applications"
    for id in ${lib.escapeShellArgs config.hiddenApps}; do
      printf '[Desktop Entry]\nType=Application\nHidden=true\n' \
        > "$out/share/applications/$id.desktop"
    done
  '';

  # ── 2. NoDisplay copies of real LibreOffice entries ───────────────────────
  # nixpkgs names LibreOffice entries writer/calc/impress/... (no "libreoffice-"
  # prefix). Writer and Calc stay visible; the rest are hidden.
  libreofficeHidden = [
    "startcenter"
    "base"
    "draw"
    "impress"
    "math"
    "xsltfilter"
  ];

  libreofficeNoDisplay = pkgs.runCommand "libreoffice-hidden-entries" { } ''
    mkdir -p "$out/share/applications"
    for id in ${lib.escapeShellArgs libreofficeHidden}; do
      src="${pkgs.libreoffice}/share/applications/$id.desktop"
      if [ -e "$src" ]; then
        sed -e '/^NoDisplay=/d' \
            -e '0,/^\[Desktop Entry\]/s//[Desktop Entry]\nNoDisplay=true/' \
            "$src" > "$out/share/applications/$id.desktop"
      else
        echo "hide-apps: $src not found, skipped" >&2
      fi
    done
  '';

in
{
  options.hiddenApps = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "org.gnome.Characters" ];
    description = "Desktop entry IDs (without .desktop) to hide from launchers completely.";
  };

  config = {
    # Install only the hidden stubs as a package.
    # This avoids collisions with LibreOffice's own desktop files.
    home.packages = [ stubs ];

    # Install the modified LibreOffice entries directly into the user's XDG
    # applications directory instead of the Home Manager buildEnv.
    xdg.dataFile = lib.genAttrs
      (map (id: "applications/${id}.desktop") libreofficeHidden)
      (path: {
        source = "${libreofficeNoDisplay}/share/applications/${builtins.baseNameOf path}";
      });
  };
}
