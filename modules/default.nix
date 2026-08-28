{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nhx;
  inherit (lib) types;
  tomlFormat = pkgs.formats.toml { };
in
{
  imports = [
    ./steel.nix
  ];

  options.programs.nhx = {
    enable = lib.mkEnableOption "nhx, declarative Helix configuration with Steel plugin support";

    package = lib.mkOption {
      type = types.nullOr types.package;
      default = pkgs.steelix;
      description = "Helix editor package (steel fork), null leaves programs.helix untouched.";
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = "Helix settings rendered into ~/.config/helix/config.toml: theme, editor, keys and everything else, same semantics as stock Helix.";
    };

    languages = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = "Helix languages rendered into ~/.config/helix/languages.toml: language-server and language entries, same semantics as stock Helix.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.file.".config/helix/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "config.toml" cfg.settings;
    };

    home.file.".config/helix/languages.toml" = lib.mkIf (cfg.languages != { }) {
      source = tomlFormat.generate "languages.toml" cfg.languages;
    };
  };
}
