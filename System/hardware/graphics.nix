# ── System/hardware/graphics.nix ───────────────────────────────────────────
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
}
