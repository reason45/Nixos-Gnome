# ── modules/hardware/graphics.nix ───────────────────────────────────────────
# Intel UHD (Comet Lake) graphics and hardware video decode.
{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true; # OpenGL/Vulkan/Mesa — required for Wayland
    # iHD VA-API driver: hardware video decode/encode on Comet Lake.
    # Makes YouTube/Firefox/video playback use the GPU = cooler laptop, longer battery.
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  # Tell VA-API apps which driver to use (iHD = intel-media-driver above).
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # Load the Intel GPU driver in the initrd, i.e. as early as possible
  # (before the root filesystem is even mounted). The backlight and the
  # display mode are then set up by i915 itself instead of firmware defaults.
  boot.initrd.kernelModules = [ "i915" ];

  # Dim-screen troubleshooting. Remove whatever does not help.
  boot.kernelParams = [
    "i915.enable_psr=0" # panel self refresh: a known cause of dim/flickering panels
    # "i915.enable_dpcd_backlight=1" # try only if PSR off changes nothing
    # "acpi_backlight=native"        # try if /sys/class/backlight has several entries
  ];
}
