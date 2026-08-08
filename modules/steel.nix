{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nhx;
  steelCfg = cfg.steel;
  initScm = import ./init-scm.nix { inherit lib; };
in
{
  options.programs.nhx.steel = {
    enable = lib.mkEnableOption "Steel plugin support for Helix";

    lsp = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          serverName = lib.mkOption {
            type = lib.types.str;
            default = "steel-language-server";
          };
          language = lib.mkOption {
            type = lib.types.str;
            default = "scheme";
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkIf (cfg.enable && steelCfg.enable) {
    home.file.".config/helix/init.scm" = {
      text = initScm.render cfg;
    };
  };
}
