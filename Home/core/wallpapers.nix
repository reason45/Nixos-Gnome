# ── Home/core/wallpapers.nix ────────────────────────────────────────────────
# Assets/wallpapers is the source of truth for wallpapers. Every image is linked
# into ~/Pictures/Wallpapers (the folder itself stays a normal writable
# directory, so you can drop your own images next to the managed ones).
# Each desktop picks its wallpaper from that folder (see Home/desktop/).
{ ... }:
{
  home.file."Pictures/Wallpapers" = {
    source = ../../Assets/wallpapers;
    recursive = true;
  };
}
