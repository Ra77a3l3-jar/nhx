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

  # local scheme files in extraRequires are installed next to init.scm
  extraFileLinks = builtins.listToAttrs (
    map (e: {
      name = ".config/helix/${initScm.fileBaseName e}";
      value.text = builtins.readFile e;
    }) cfg.extraRequires
  );
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

    coreRequires = lib.mkOption {
      type = lib.types.mkOptionType {
        name = "coreRequires";
        description = "list of paths relative to the config file, resolved as module names from STEEL_HOME/cogs";
        merge =
          loc: defs:
          lib.concatLists (
            map (
              d:
              map (e: lib.removePrefix (builtins.dirOf d.file + "/") (toString e)) d.value
            ) defs
          );
      };
      default = [ ];
      example = lib.literalExpression "[ ./helix/treesitter.scm ]";
      description = "Core scheme files from STEEL_HOME/cogs, given as paths relative to the config file, required at the top of init.scm and added to the defaults (duplicates dropped).";
    };

    extraRequires = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression "[ ./extra.scm ]";
      description = "Local scheme files, given as paths relative to the config file, installed next to init.scm and required by their basename.";
    };
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
      // extraFileLinks
      // {
        ".config/helix/init.scm" = {
          text = initScm.render cfg;
        };
      };
  };
}
