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
  name = "who-unstable";
  requirePath = "who/who.scm";
  options = {
    color = mkOption {
      type = types.nullOr types.str;
      default = "#94e2d5";
      description = "who-set-color!: color for the who indicator, null to omit the call.";
    };
  };
  render = cfg: if cfg.color != null then s.call "who-set-color!" [ (s.str cfg.color) ] else "";
}
