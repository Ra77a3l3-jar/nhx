{ lib }:
let
  inherit (lib)
    types
    mkOption
    optionals
    ;
  s = import ../../lib/scheme.nix { inherit lib; };
  p = import ./lib.nix { inherit lib; };
in
p.mkPluginDescriptor {
  name = "scopeline";
  options = {
    bg = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Bar background null/false for theme background.";
    };
    separator = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "String drawn between breadcrumb levels, e.g. ›";
    };
    maxDepth = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Deepest levels to keep, 0 for all.";
    };
    showFile = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Leading file icon and name.";
    };
  };
  render =
    cfg:
    s.call "scopeline-configure!" (
      optionals (cfg.bg != null) [
        (s.kw "bg")
        (s.str cfg.bg)
      ]
      ++ optionals (cfg.separator != null) [
        (s.kw "separator")
        (s.str cfg.separator)
      ]
      ++ optionals (cfg.maxDepth != null) [
        (s.kw "max-depth")
        (toString cfg.maxDepth)
      ]
      ++ optionals (cfg.showFile != null) [
        (s.kw "show-file?")
        (s.bool cfg.showFile)
      ]
    );
}
