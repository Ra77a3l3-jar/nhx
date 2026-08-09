{ lib }:
let
  inherit (lib)
    types
    mkOption
    ;
  s = import ../../lib/scheme.nix { inherit lib; };
  p = import ./lib.nix { inherit lib; };
in
p.mkPluginDescriptor {
  name = "notify";
  options = {
    render = mkOption {
      type = types.nullOr (
        types.enum [
          "default"
          "minimal"
        ]
      );
      default = null;
      description = "notify-config 'render: popup style, 'default or 'minimal.";
    };
  };
  render =
    cfg:
    if cfg.render != null then
      s.call "notify-config" [
        (s.sym "render")
        (s.sym cfg.render)
      ]
    else
      "";
}
