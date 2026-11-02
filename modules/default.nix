{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nhx;
  inherit (lib) types;
  tomlFormat = pkgs.formats.toml { };
in
{
  imports = [
    ./steel.nix
  ]
  ++ map (name: lib.mkAliasOptionModule [ "programs" "nhx" name ] [ "programs" "helix" name ]) [
    "defaultEditor"
    "extraConfig"
    "extraPackages"
    "themes"
    "ignores"
  ];

  options.programs.nhx = {
    enable = lib.mkEnableOption "nhx, declarative Helix configuration with Steel plugin support";

    package = lib.mkOption {
      type = types.nullOr types.package;
      default = pkgs.steelix;
      description = "Helix editor package (steel fork), null leaves programs.helix.package untouched.";
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
    programs.helix = {
      enable = lib.mkDefault true;
      package = lib.mkIf (cfg.package != null) (lib.mkDefault cfg.package);
      settings = lib.mkIf (cfg.settings != { }) cfg.settings;
      languages = lib.mkIf (cfg.languages != { }) cfg.languages;
    };
  };
}
