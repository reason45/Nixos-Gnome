# ── home/shell/starship.nix ─────────────────────────────────────────────────
# Starship = the colourful Powerline prompt. The look is defined in
# starship.toml next to this file (Catppuccin Mocha palette).
# Needs a Nerd Font in the terminal — provided by modules/desktop/fonts.nix.
{ ... }:
{
  programs.starship.enable = true; # also hooks starship into bash

  # Install our own config file as ~/.config/starship.toml
  xdg.configFile."starship.toml".source = ./starship.toml;
}
