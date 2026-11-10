# ── Home/core/shell/starship.nix ────────────────────────────────────────────
# Starship = the prompt, using the official "Nerd Font Symbols" preset
# (https://starship.rs/presets/nerd-font): icons only, layout and colours are
# Starship's defaults.
#
# The preset is generated from the installed Starship itself, so it can never
# contain OS names or modules the installed version doesn't know (a preset
# copied from the website is newer and makes Starship print config warnings).
#
# Needs a Nerd Font in the terminal — provided by System/core/fonts.nix.
{ ... }:
{
  programs.starship = {
    enable = true; # also hooks starship into bash
    presets = [ "nerd-font-symbols" ];
  };
}
