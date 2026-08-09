# Contributing

Thanks for contributing to nhx! Please keep plugin packaging and plugin
configuration separate, and follow the layout below.

## Adding a plugin

1. **Package it.** Add a derivation under
   [`pkgs/helixPlugins/`](pkgs/helixPlugins/), using an existing plugin as a
   template. Use `buildHelixPlugin`, or `buildHelixPluginWithNative` if the
   plugin has native dependencies. Set `cogName` to the name used in the
   plugin's `(require ...)` path, and fill in its metadata and dependencies.

   Packages here are picked up automatically by `pkgs/default.nix` — no
   separate index to update.

   Before packaging, check the plugin's upstream source and docs for
   configuration options, commands, and init requirements.

2. **Add a config module (if needed).** If the plugin exposes configuration
   worth representing in Nix, add a descriptor under [`modules/plugins/`](modules/plugins/):

   - Define the supported options with appropriate Nix types and defaults.
   - Render them to valid Scheme using the helpers in [`modules/plugins/lib.nix`](modules/plugins/lib.nix) and [`lib/scheme.nix`](lib/scheme.nix).
   - Register it in [`modules/plugins/registry.nix`](modules/plugins/registry.nix).

   The descriptor's plugin name must match the package's `cogName`.

## Checklist

- Plugin derivation added under `pkgs/helixPlugins/`
- Package builds, `cogName` is correct
- Upstream checked for config/init requirements
- Config descriptor added and registered (if applicable)
- Changed Nix files formatted with the flake formatter: `nix fmt`
