{ ... }: 

{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "nixos_small";
        padding.right = 2;
      };

      display = {
        color.keys = "blue";
        separator = "  ";
        brightColor = false;
      };

      modules = [
        "break"

        # System Information
        {
          type = "title";
          key = "┌────────────";
        }
        {
          type = "separator";
          key = "├────────────";
        }
        {
          type = "os";
          key = "│  OS";
        }
        {
          type = "host";
          key = "│  Host";
        }
        {
          type = "kernel";
          key = "│  Kernel";
        }
        {
          type = "locale";
          key = "│  Locale";
        }

        # Hardware
        {
          type = "custom";
          key = "│";
          format = "{#bright_cyan}├─────────── Hardware ───────────┤";
        }
        {
          type = "cpu";
          key = "│  CPU";
          format = "{name} @{freq-max}";
          showPeCoreCount = false;
        }
        {
          type = "gpu";
          key = "│  GPU";
        }
        {
          type = "memory";
          key = "│  RAM";
        }
        {
          type = "swap";
          key = "│  SWAP";
        }
        {
          type = "disk";
          key = "│  Disk";
          format = "{size-used} / {size-total} ({size-percentage}) - {filesystem}";
        }
        {
          type = "battery";
          key = "│  Battery";
        }
        {
          type = "custom";
          key = "│";
          format = "{#bright_cyan}└────────────────────────────────┘";
        }

        # Desktop
        {
          type = "custom";
          key = "│";
          format = "{#bright_green}├─────────── Desktop ────────────┤";
        }
        {
          type = "de";
          key = "│  Desktop";
        }
        {
          type = "wm";
          key = "│  Session";
        }
        {
          type = "gpu";
          key = "│  G-Driver";
          format = "{driver}";
        }
        {
          type = "custom";
          key = "│";
          format = "{#bright_green}└────────────────────────────────┘";
        }

        # Uptime
        {
          type = "custom";
          key = "│";
          format = "{#bright_magenta}├─────────── Uptime ─────────────┤";
        }
        {
          type = "uptime";
          key = "│  Uptime";
        }
        {
          type = "disk";
          folders = [ "/" ];
          key = "│  OS Age";
          format = "{create-time:10} [{days} days]";
          condition = {
            "!system" = "macOS";
          };
        }
        {
          type = "custom";
          key = "│";
          format = "{#bright_magenta}└────────────────────────────────┘";
        }

        "break"
      ];
    };
  };
}

