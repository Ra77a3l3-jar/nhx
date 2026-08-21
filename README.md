# nhx

[Codeberg Repo](https://codeberg.org/Ra77a3l3-jar/nhx) | [GitHub Mirror](https://github.com/Ra77a3l3-jar/nhx)

Declarative Helix configuration for Nix, with Steel plugin support.

nhx is a Home Manager module that manages Helix settings, installs Steel
plugins, configures them and generates `init.scm` from your Nix configuration.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) to package new
plugins and adding their optional Nix configuration.

## Usage

Add nhx to your flake inputs and import its Home Manager module:

```nix
{
  inputs.nhx.url = "https://codeberg.org/Ra77a3l3-jar/nhx.git";

  outputs = { nixpkgs, home-manager, nhx, ... }: {
    homeConfigurations.me = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        nhx.homeManagerModules.nhx
        ./home.nix
      ];
    };
  };
}
```

Then configure Helix in `home.nix`:

```nix
{ inputs, helix-steel, helixPlugins, ... }:

{
  imports = [
    inputs.nhx.homeManagerModules.default
  ];

  programs.nhx = {
    enable = true;

    # Normal helix config in nix
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
      };
    };

    steel = {
      enable = true;
      lsp.enable = true;
    };

    plugins = with helixPlugins [
      oil
      moka
      scooter
    ];

    # Enable and configure a plugin with an attribute set.
    plugins = {
      forest = {
        enable = true;
        config = {
          style = "snacks";
          position = "left";
          ignore = [
            ".git"
            "target"
            ".cache"
            "pycache"
          ];
          sidebarBg = {
            focused = "#1e1e2e";
            unfocused = "#181825";
          };
          searchColor = {
            focused = "#89b4fa";
            unfocused = "#6c7086";
            always = null;
            followFocus = true;
          };
        };
      };

      oil = {
        enable = true;
        config = {
          showDotfiles = true;
          keymaps.normal."ret" = ":oil-enter";
        };

        # scheme for any config that cannot be set with nix
        extra = ''
          (oil-configure! #t)
        '';
      };
    };
  };
}
```

Mentioning a plugin installs it. Set `enable = true` to add its `require`
form to the generated `~/.config/helix/init.scm`.

## Repository layout

- [`pkgs/helixPlugins/`](pkgs/helixPlugins/) contains the package derivations
  for the available Helix plugins.
- [`modules/plugins/`](modules/plugins/) contains the Nix module definitions
  for plugins with Nix configuration. Their descriptors render configuration
  to Scheme and are registered in
  [`modules/plugins/registry.nix`](modules/plugins/registry.nix).
- [`modules/`](modules/) contains the main Home Manager module and Steel
  integration.

## License

nhx is licensed under the [Apache License 2.0](LICENSE). Each packaged plugin
is developed and licensed by its own upstream project; refer to the
corresponding plugin project for its license and terms

## Credit

The plugin derivations and package builder are from [helix-plugins-nix](https://codeberg.org/maxschipper/helix-plugins-nix).
