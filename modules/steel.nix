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
      name = ".config/helix/${e.name}";
      value.text = builtins.readFile e.path;
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
      type = lib.types.mkOptionType {
        name = "extraRequires";
        description = "list of scheme files given as paths relative to the config file, installed next to init.scm";
        merge =
          loc: defs:
          lib.concatLists (
            map (
              d:
              map (
                e:
                let
                  path = toString e;
                  configDir = builtins.dirOf d.file + "/";
                  rel = lib.removePrefix configDir path;
                in
                {
                  # files under the config dir keep their relative path, so
                  # foo/bar.scm and baz/bar.scm do not collide; anything else
                  # falls back to its basename
                  name = if rel != path then rel else lib.last (lib.splitString "/" path);
                  inherit path;
                }
              ) d.value
            ) defs
          );
      };
      default = [ ];
      example = lib.literalExpression "[ ./extra.scm ]";
      description = "Local scheme files, given as paths relative to the config file, installed next to init.scm and required by their path relative to it.";
    };
  };

  options.programs.nhx.steel = {
    enable = lib.mkEnableOption "Steel plugin support for Helix";

    extra = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = lib.literalExpression ''
        (when (equal? (command-line) '("hx"))
          (show-splash))
      '';
      description = "Raw scheme appended at the end of the generated init.scm, for things that cannot be configured with the existing options.";
    };

    lsp = {
      enable = lib.mkEnableOption "Steel lsp" // {
        default = true;
      };
      serverName = lib.mkOption {
        type = lib.types.str;
        default = "steel-language-server";
        description = "Name of the Steel language server configuration.";
      };
      language = lib.mkOption {
        type = lib.types.str;
        default = "scheme";
        description = "Language for which the Steel lsp will be used.";
      };
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
