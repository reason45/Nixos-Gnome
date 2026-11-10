# ── Home/desktop/gnome/text-editor.nix ──────────────────────────────────────

{ ... }:

{
  dconf.settings."org/gnome/TextEditor" = {
    show-line-numbers = true;
    highlight-current-line = true;
    auto-indent = true;
    restore-session = false;
  };
}
