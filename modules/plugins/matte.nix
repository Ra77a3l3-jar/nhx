{ lib }:
let
  inherit (builtins) toString;
  inherit (lib)
    types
    mkOption
    optionals
    concatStringsSep
    ;
  s = import ../../lib/scheme.nix { inherit lib; };
  p = import ./lib.nix { inherit lib; };
in
p.mkPluginDescriptor {
  name = "matte";
  options = {
    width = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "matte-width!: columns of text.";
    };
    padding = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "matte-padding!: inset top and bottom rows.";
    };
    softWrap = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "matte-soft-wrap!: soft wrap at the measure.";
    };
    bufferline = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "matte-bufferline!: hide the bufferline.";
    };
    gutterCompensation = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "matte-gutter-compensation!: centre the text, not the view.";
    };
  };
  render =
    cfg:
    concatStringsSep "\n" (
      lib.optional (cfg.width != null) (s.call "matte-width!" [ (toString cfg.width) ])
      ++ lib.optional (cfg.padding != null) (s.call "matte-padding!" [ (toString cfg.padding) ])
      ++ lib.optional (cfg.softWrap != null) (s.call "matte-soft-wrap!" [ (s.bool cfg.softWrap) ])
      ++ lib.optional (cfg.bufferline != null) (s.call "matte-bufferline!" [ (s.bool cfg.bufferline) ])
      ++ lib.optional (cfg.gutterCompensation != null) (
        s.call "matte-gutter-compensation!" [ (s.bool cfg.gutterCompensation) ]
      )
    );
}
