# ── modules/core/users.nix ──────────────────────────────────────────────────
# Your login account. The login name comes from `user` in flake.nix.
{ user, ... }:
{
  users.users.${user} = {
    isNormalUser = true; # a real person, not a system service
    description = "Sanjaya"; # display name shown on the GDM login screen
    extraGroups = [
      "networkmanager" # manage Wi-Fi without a password prompt
      "wheel" # allowed to use sudo
    ];
  };
}
