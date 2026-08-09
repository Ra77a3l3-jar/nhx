{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nhx;
  steelCfg = cfg.steel;
  initScm = import ./init-scm.nix { inherit lib; };
  pluginLib = import ./plugins/lib.nix { inherit lib; };

  # the plugin set packaged by nhx (see ./pkgs)
  helixPlugins = pkgs.callPackage ../pkgs { };

  steelHome =
    config.home.sessionVariables.STEEL_HOME or "${config.home.homeDirectory}/.local/share/steel";

  # home.file targets must be relative to the home directory
  steelHomeRel = lib.removePrefix "${config.home.homeDirectory}/" steelHome;

  cogName = drv: drv.cogName or drv.pluginName or (throw "plugin package is missing a cogName/pluginName passthru");
  pluginDeps = drv: drv.pluginDependencies or drv.dependencies or [ ];

  # includes plugin dependencies with passthru
  flattenPlugins =
    plugins:
    map (item: item.val) (
      lib.genericClosure {
        startSet = map (p: {
          key = cogName p;
          val = p;
        }) plugins;
        operator = item: map (p: {
          key = cogName p;
          val = p;
        }) (pluginDeps item.val);
      }
    );

  resolvePackage = name: p:
    if p.package != null then
      p.package
    else
      helixPlugins.${name}
      or (throw ''
        plugin "${name}" is not packaged in nhx.
        Open a PR to nhx adding it to pkgs/helixPlugins/.
      '');

  # every plugin mentioned in the plugins option is installed into STEEL_HOME
  installedPlugins = lib.attrNames cfg.plugins;

  installedPackages = map (name: resolvePackage name cfg.plugins.${name}) installedPlugins;

  allPlugins = flattenPlugins installedPackages;
  # pure plugins carry passthru.native = null (or no native attr); native plugins
  # expose a `native` output or passthru attr
  nativePlugins = builtins.filter (drv: (drv.native or null) != null) allPlugins;

  cogLinks = builtins.listToAttrs (
    map (drv: {
      name = "${steelHomeRel}/cogs/${cogName drv}";
      value.source = drv;
    }) allPlugins
  );

  nativeLinks = lib.optionalAttrs (nativePlugins != [ ]) {
    "${steelHomeRel}/native".source = pkgs.symlinkJoin {
      name = "nhx-merged-native-libs";
      paths = map (drv: drv.native) nativePlugins;
    };
  };
in
{
  options.programs.nhx = {
    availablePlugins = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = helixPlugins;
      defaultText = lib.literalExpression "nhx's own plugin set (pkgs/helixPlugins)";
      description = "Every plugin packaged by nhx, e.g. for programs.nhx.plugins.<name>.package.";
    };

    plugins = pluginLib.mkPluginsOption (import ./plugins/registry.nix { inherit lib; });
  };

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
    # short binding so configs can write plugins = with helixPlugins; [ ... ];
    _module.args.helixPlugins = config.programs.nhx.availablePlugins;

    home.file =
      cogLinks
      // nativeLinks
      // {
        ".config/helix/init.scm" = {
          text = initScm.render cfg;
        };
      };
  };
}
