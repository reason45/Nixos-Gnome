# ── System/core/home-manager.nix ────────────────────────────────────────────
# Integrated Home Manager: built and activated together with the system.
# The user config lives in ./Home (this repo's Home directory).
#
# "Integrated" (NixOS-module mode) means you never run `home-manager switch`
# yourself — `rebuild` does both in one go.
#
# `inputs`, `user` and `host` come from flake.nix (specialArgs) and are handed
# on to every Home Manager module through extraSpecialArgs.
{ inputs, user, host, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true; # reuse the system's nixpkgs (and its allowUnfree)
    useUserPackages = true; # home.packages install into /etc/profiles
    backupFileExtension = "backup"; # existing files are renamed to *.backup, never fatal
    overwriteBackup = true; # ...and an older *.backup is replaced instead of aborting

    extraSpecialArgs = { inherit inputs user host; };

    # Load ../../Home/default.nix as this user's configuration.
    users.${user} = ../../Home;
  };
}
