{ lib }:
let
  inherit (lib)
    types
    mkOption
    optionals
    concatStringsSep
    ;
  s = import ../../lib/scheme.nix { inherit lib; };
  p = import ./lib.nix { inherit lib; };
  initScm = import ../init-scm.nix { inherit lib; };
in
p.mkPluginDescriptor {
  name = "oil";
  options = {
    showDotfiles = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "oil configure, show hidden dotfiles by default.";
    };
    showGitIgnored = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "oil configure, show git ignored files by default.";
    };
    keymaps = mkOption {
      type = types.attrs;
      default = { };
      description = "Keymaps for the oil buffer, mode to nested keys to command.";
    };
  };
  render =
    cfg:
    concatStringsSep "\n" (
      lib.optional (cfg.showDotfiles != null || cfg.showGitIgnored != null) (
        s.call "oil-configure!" [
          (if cfg.showDotfiles != null then s.bool cfg.showDotfiles else s.bool false)
          (if cfg.showGitIgnored != null then s.bool cfg.showGitIgnored else s.bool false)
        ]
      )
      ++ lib.optional (cfg.keymaps != { }) (initScm.renderOilKeymaps cfg.keymaps)
    );
}
