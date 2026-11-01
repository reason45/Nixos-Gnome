# ── home/apps/mimeapps.nix ──────────────────────────────────────────────────
# Default apps ("Open with…" defaults). GNOME apps for GNOME things,
# LibreOffice for Office files.
# Result is written to ~/.config/mimeapps.list.
#
# Find a file's MIME type:  file --mime-type <file>
# Find an app's .desktop name:  ls /run/current-system/sw/share/applications
{ lib, ... }:

let
  # Helper: map one app to many MIME types.
  assign = app: types: lib.genAttrs types (_: app);

  # App short-names (the .desktop file that launches each one).
  firefox = "firefox.desktop";
  nautilus = "org.gnome.Nautilus.desktop"; # Files
  papers = "org.gnome.Papers.desktop"; # PDF viewer
  loupe = "org.gnome.Loupe.desktop"; # Image viewer
  editor = "org.gnome.TextEditor.desktop";
  roller = "org.gnome.FileRoller.desktop"; # Archives
  showtime = "org.gnome.Showtime.desktop"; # Video player
  decibels = "org.gnome.Decibels.desktop"; # Audio player
  writer = "writer.desktop"; # LibreOffice Writer
  calc = "calc.desktop"; # LibreOffice Calc
  impress = "impress.desktop"; # LibreOffice Impress
in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications =
      # Web
      assign firefox [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
        "image/svg+xml"
      ]

      # PDF
      // assign papers [ "application/pdf" ]

      # File manager
      // assign nautilus [ "inode/directory" ]

      # Archives
      // assign roller [
        "application/zip"
        "application/gzip"
        "application/x-tar"
        "application/x-compressed-tar"
        "application/x-xz"
        "application/x-7z-compressed"
        "application/vnd.rar"
      ]

      # Text and code
      // assign editor [
        "text/plain"
        "text/markdown"
        "application/json"
        "application/x-shellscript"
        "text/x-python"
      ]

      # Images
      // assign loupe [
        "image/png"
        "image/jpeg"
        "image/webp"
        "image/gif"
        "image/tiff"
        "image/bmp"
        "image/avif"
      ]

      # Video
      // assign showtime [
        "video/mp4"
        "video/webm"
        "video/x-matroska"
        "video/ogg"
        "video/x-msvideo"
        "video/quicktime"
      ]

      # Audio
      // assign decibels [
        "audio/mpeg"
        "audio/ogg"
        "audio/flac"
        "audio/x-flac"
        "audio/wav"
        "audio/x-wav"
        "audio/mp4"
        "audio/aac"
        "audio/opus"
      ]

      # Office: documents
      // assign writer [
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.oasis.opendocument.text"
        "application/msword"
        "application/rtf"
      ]

      # Office: spreadsheets
      // assign calc [
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.ms-excel"
        "text/csv"
      ]

      # Office: presentations
      // assign impress [
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.oasis.opendocument.presentation"
        "application/vnd.ms-powerpoint"
      ];
  };
}
