# ── modules/core/home-manager.nix ───────────────────────────────────────────
# Integrated Home Manager: built and activated together with the system.
# The user config lives in /home (this repo's ./home directory).
#
# "Integrated" (NixOS-module mode) means you never run `home-manager switch`
# yourself — `rebuild` does both in one go.
{ user, ... }: # `user` comes from flake.nix (specialArgs)
{
  home-manager = {
    useGlobalPkgs = true; # reuse the system's nixpkgs (and its allowUnfree)
    useUserPackages = true; # home.packages install into /etc/profiles
    backupFileExtension = "backup"; # existing files are renamed to *.backup, never fatal
    overwriteBackup = true; # ...and an older *.backup is replaced instead of aborting

    # Load ../../home/default.nix as this user's configuration.
    users.${user} = import ../../home;
  };
}
