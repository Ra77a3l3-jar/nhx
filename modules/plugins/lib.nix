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
      requirePath ? null,
    }:
    {
      inherit name options render requirePath;
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
                default = false;
                description = "Whether to require this plugin in the generated init.scm. Mentioning a plugin installs it, enable adds the require.";
              };
              package = mkOption {
                type = types.nullOr types.package;
                default = null;
                description = "Override the packaged plugin derivation. Defaults to nhx's package for this plugin name.";
              };
              requirePath = mkOption {
                type = types.nullOr types.str;
                default = registry.${name}.requirePath or null;
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
              value =
                if builtins.isList d.value then
                  lib.listToAttrs (
                    map (
                      entry:
                      if lib.isDerivation entry then
                        lib.nameValuePair
                          (entry.cogName or entry.pluginName
                            or (throw "plugin package is missing a cogName/pluginName passthru")
                          )
                          {
                            package = entry;
                          }
                      else
                        lib.nameValuePair entry { }
                    ) d.value
                  )
                else
                  d.value;
            }) defs
          );
      };
    in
    mkOption {
      type = pluginsType;
      default = { };
      description = "Steel plugins to install and require. Either a list of names or packages, or an attrset of per plugin options.";
    };
}
