# Builds the plugins option from per plugin descriptors.
# Descriptors carry the name, the config options and the Scheme renderer.
{ lib }:
let
  inherit (lib) types mkOption mkIf;
in
rec {
  mkPluginDescriptor =
    {
      name,
      options ? { },
      render ? (cfg: ""),
    }:
    {
      inherit name options render;
    };

  mkPluginsOption = descriptors:
    let
      registry = lib.listToAttrs (map (d: {
        name = d.name;
        value = d;
      }) descriptors);

      pluginType = types.attrsOf (
        types.submodule (
          { config, name, ... }: {
            options = {
              enable = mkOption {
                type = types.bool;
                default = true;
                description = "Whether to install and require this plugin.";
              };
              package = mkOption {
                type = types.nullOr types.package;
                default = null;
                description = "Override the packaged plugin derivation. Defaults to nhx's package for this plugin name.";
              };
              requirePath = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Path used in the generated (require ...) line. Defaults to <name>/<name>.scm.";
              };
              extra = mkOption {
                type = types.lines;
                default = "";
                description = "Raw Scheme appended after this plugin's section.";
              };
              config = mkOption {
                type = types.submodule {
                  options = registry.${name}.options or { };
                };
                default = { };
                description = "Configuration options for the ${name} plugin.";
              };
              rendered = mkOption {
                type = types.lines;
                internal = true;
                default = "";
                description = "Generated Scheme section for this plugin. Do not set manually.";
              };
            };

            config.rendered = mkIf config.enable ((registry.${name}.render or (cfg: "")) config.config);
          }
        )
      );

      # List definitions become per plugin entries before the merge.
      pluginsType = types.mkOptionType {
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
    in
    mkOption {
      type = pluginsType;
      default = { };
      description = "Steel plugins to install and require. Either a list of names or an attrset of per plugin options.";
    };
}
