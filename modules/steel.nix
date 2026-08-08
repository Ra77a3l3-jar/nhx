{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nhx;
  steelCfg = cfg.steel;
  initScm = import ./init-scm.nix { inherit lib; };

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

  enabledPlugins = lib.attrNames (lib.filterAttrs (name: p: p.enable) steelCfg.plugins);

  enabledPackages = map (name: resolvePackage name steelCfg.plugins.${name}) enabledPlugins;

  allPlugins = flattenPlugins enabledPackages;
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
  options.programs.nhx.steel = {
    enable = lib.mkEnableOption "Steel plugin support for Helix";

    availablePlugins = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = helixPlugins;
      defaultText = lib.literalExpression "nhx's own plugin set (pkgs/helixPlugins)";
      description = "Every plugin packaged by nhx, e.g. for programs.nhx.steel.plugins.<name>.package.";
    };

    plugins =
      let
        pluginType = lib.types.attrsOf (lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to install and require this plugin.";
            };
            package = lib.mkOption {
              type = lib.types.nullOr lib.types.package;
              default = null;
              description = "Override the packaged plugin derivation. Defaults to nhx's package for this plugin name.";
            };
            requirePath = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Path used in the generated (require ...) line. Defaults to <name>/<name>.scm.";
            };
            extra = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Raw Scheme appended after this plugin's require line.";
            };
          };
        });
      in
      lib.mkOption {
        type = lib.types.mkOptionType {
          name = "nhxPlugins";
          description = "list of plugin names, or attrset of per plugin options";
          check = v: builtins.isList v || builtins.isAttrs v;
          merge =
            loc: defs:
            pluginType.merge loc (
              map (d: {
                inherit (d) file;
                value = if builtins.isList d.value then lib.genAttrs d.value (n: { }) else d.value;
              }) defs
            );
        };
        default = { };
        description = "Steel plugins to install and require. Either a list of names or an attrset of per plugin options.";
      };

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
