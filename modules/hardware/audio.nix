# ── modules/hardware/audio.nix ──────────────────────────────────────────────
# Sound via PipeWire — the modern audio server (replaces PulseAudio + JACK).
{ ... }:
{
  services.pulseaudio.enable = false; # PipeWire takes over; the two conflict
  security.rtkit.enable = true; # lets PipeWire get realtime priority (no crackling)
  services.pipewire = {
    enable = true;
    alsa.enable = true; # apps that talk to ALSA directly
    alsa.support32Bit = true; # 32-bit apps (Steam, Wine)
    pulse.enable = true; # apps that expect PulseAudio keep working
  };
}
