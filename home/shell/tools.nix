# ── home/shell/tools.nix ────────────────────────────────────────────────────
# Small CLI tools that need no configuration beyond being enabled.
# Home Manager also wires up their bash integration where applicable.
{ ... }:
{
  programs.bat.enable = true; # `bat file` = cat with syntax highlighting + paging

  # ── Added during the config review (all optional, delete what you don't use)
  programs.fzf.enable = true; # fuzzy finder: Ctrl+R history search, Ctrl+T file picker
  programs.ripgrep.enable = true; # `rg text` = very fast recursive grep
  programs.fd.enable = true; # `fd name` = friendlier, faster `find`

  # direnv + nix-direnv: put a `.envrc` with `use flake` in a project folder
  # and its dev-shell (compilers, node, python...) loads automatically on `cd`.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
