# ── System/hardware/memory.nix ─────────────────────────────────────────────
# Memory tuning for 8 GB of RAM: zram first, swapfile as overflow,
# and early OOM handling to keep the desktop responsive.
#
# Check it with:  swapon --show   |   free -h   |   zramctl
{ ... }:
{
  # Compressed swap in RAM (default priority 5, used before the swapfile).
  # zstd typically compresses 2-3x, so 50% of RAM ≈ 4 GB of swap that is
  # far faster than a disk.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Disk swap overflow; lower priority than zram. With `size` set, NixOS
  # creates the file itself if it is missing (an existing file is left alone).
  swapDevices = [
    { device = "/swapfile"; size = 4096; priority = 0; } # size is in MiB (= 4 GiB)
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100; # let the kernel use zram readily
    "vm.page-cluster" = 0; # no swap readahead (good for zram)
  };

  # Kills the worst offender under severe memory pressure instead of freezing.
  # Acts only when BOTH RAM and swap are low. Defaults (10 %/10 %) would wait
  # until the SSD swapfile is nearly full and the machine is already thrashing.
  # 5 % RAM + 40 % swap free = zram full plus a little SSD swap: kill before that
  # becomes a freeze. A desktop may protect its own session processes with
  # services.earlyoom.extraArgs (see System/desktop/).
  services.earlyoom = {
    enable = true;
    enableNotifications = true; # tell you which app was killed
    freeMemThreshold = 5;
    freeSwapThreshold = 40;
  };
}
