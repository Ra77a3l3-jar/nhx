{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nhx;

  helixOptions = [
    "enable"
    "package"
    "extraPackages"
    "extraConfig"
    "defaultEditor"
    "settings"
    "languages"
    "ignores"
    "themes"
  ];
in
{
  imports = [
    ./steel.nix
  ]
  ++ map (
    name: lib.mkAliasOptionModule [ "programs" "nhx" name ] [ "programs" "helix" name ]
  ) helixOptions;

  config = lib.mkIf cfg.enable {
    programs.helix.package = lib.mkDefault pkgs.steelix;
  };
}
