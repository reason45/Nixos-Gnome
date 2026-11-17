
{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/Console" = {
      # Appearance
      theme = "auto";

      # Font
      use-system-font = false;
      custom-font = "JetBrainsMono Nerd Font 12";
      font-scale = 1.0;

      # Scrolling
      scrollback-lines = 10000;
      ignore-scrollback-limit = false;

      # Alerts
      audible-bell = false;
      visual-bell = false;

      # Behavior
      transparency = false;
      restore-window-size = true;
      software-flow-control = false;
    };
  };
}

