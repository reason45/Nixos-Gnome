# ── Home/desktop/gnome/weather.nix ──────────────────────────────────────────
# Weather location: Butwal, Nepal.
# Coordinates are in radians, as required by GNOME Weather.

{ lib, ... }:

let
  g = lib.hm.gvariant;

  butwal = g.mkVariant (
    g.mkTuple [
      (g.mkUint32 2)
      (g.mkVariant (
        g.mkTuple [
          "Butwal"
          ""
          false
          [
            (g.mkTuple [
              0.48346667477794125
              1.4564493355212362
            ])
          ]
          (g.mkEmptyArray (g.type.tupleOf [
            g.type.double
            g.type.double
          ]))
        ]
      ))
    ]
  );
in
{
  dconf.settings = {
    "org/gnome/Weather" = {
      locations = [ butwal ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = false;
      locations = [ butwal ];
    };

    # Show temperatures in °C instead of °F.
    # Use "org/gnome/GWeather" instead on GNOME < 40.
    "org/gnome/GWeather4" = {
      temperature-unit = "centigrade";
    };
  };
}
