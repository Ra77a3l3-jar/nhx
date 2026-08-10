{ runCommand, lib, pkgs }:
let
  nhxModule = import ../modules;

  # minimal home stub with nhx needed settings
  homeStub = { lib }: {
    options.home = {
      homeDirectory = lib.mkOption { type = lib.types.str; };
      sessionVariables = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
      file = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.text = lib.mkOption { type = lib.types.str; };
          options.source = lib.mkOption { type = lib.types.path; };
        });
        default = { };
      };
    };
  };

  result = lib.evalModules {
    modules = [
      { config._module.args = { inherit lib pkgs; }; }
      (homeStub { inherit lib; })

      # list installs without config and without require
      ({ helixPlugins, ... }: {
        programs.nhx.plugins = with helixPlugins; [ scooter trail splash-hx];
      })

      {
        programs.nhx = {
          enable = true;

          settings = {
            theme = "catppuccin_mocha";
            editor.line-number = "relative";
          };

          coreRequires = [ helix/treesitter.scm ];

          steel = {
            enable = true;

            extra = ''
              (when (equal? (command-line) '''("hx"))
                (show-splash))
            '';
          };
        };

        programs.nhx.plugins.forest = {
          enable = true;
          config = {
            style = "snacks";
            position = "left";
          };
        };

        programs.nhx.plugins.moka = {
          enable = true;
          config = {
            sections = [
              {
                align = "left";
                segments = [ { kind = "mode"; } ];
              }
            ];
            bufferline.gap = 1;
          };
        };

        programs.nhx.plugins.notify = {
          enable = true;
          config.render = "minimal";
          extra = ''
            (notify-config 'timeout 5000)
          '';
        };

        programs.nhx.plugins.oil = {
          enable = true;
          config = {
            showDotfiles = true;
            keymaps.normal = {
              "ret" = ":oil-enter";
            };
          };
        };
      }

      nhxModule
      { home.homeDirectory = "/home/user"; }
    ];
  };

  files = result.config.home.file;
  initScm = files.".config/helix/init.scm".text;

  # check generated init.scm checked before the build
  assertHas = expected:
    if lib.hasInfix expected initScm then
      true
    else
      throw "nhx check: init.scm does not contain: ${expected}";

  assertLacks = unexpected:
    if lib.hasInfix unexpected initScm then
      throw "nhx check: init.scm should not contain: ${unexpected}"
    else
      true;

  asserts = [
    # check for requires
    (assertHas "(require \"helix/configuration.scm\")")
    (assertHas "(require \"helix/treesitter.scm\")")
    (assertHas "(require \"forest/forest.scm\")")
    (assertHas "(require \"moka/moka.scm\")")
    (assertHas "(require \"notify/notify.scm\")")
    (assertHas "(require \"oil/oil.scm\")")
    (assertLacks "scooter")
    (assertLacks "trail")

    # config check
    (assertHas "(forest-set-style! 'mini)")
    (assertHas "(forest-configure! 'left")
    (assertHas "(moka-configure!")
    (assertHas "(moka-enable!)")
    (assertHas "(moka-bufferline-configure!")
    (assertHas "(notify-config 'render 'minimal)")
    (assertHas "(notify-config 'timeout 5000)")
    (assertHas "(oil-configure! #t #f)")
    (assertHas "(define oil-keymaps")
    (assertHas "(set-global-buffer-or-extension-keymap")

    # extra steel config
    (assertHas "(when (equal? (command-line) ''(\"hx\"))")
    (assertHas "(show-splash)")
  ];

  # generated file
  expectedFiles = [
    ".config/helix/init.scm"
    ".config/helix/config.toml"
    ".config/helix/languages.toml"
  ];

  # installed plugins
  expectedCogs = map (c: ".local/share/steel/cogs/${c}") [
    "forest"
    "glyph"
    "moka"
    "notify"
    "oil"
    "scooter"
    "trail"
  ];

  missingFiles = lib.subtractLists (builtins.attrNames files) expectedFiles;

  installedCogs = builtins.attrNames (
    lib.filterAttrs (n: v: lib.hasPrefix ".local/share/steel/cogs/" n) files
  );

  missingCogs = lib.subtractLists installedCogs expectedCogs;
in
builtins.seq asserts (
  if missingFiles != [ ] then
    throw "nhx check: missing files: ${lib.concatStringsSep ", " missingFiles}"
  else if missingCogs != [ ] then
    throw "nhx check: missing cogs: ${lib.concatStringsSep ", " missingCogs}"
  else
    runCommand "nhx-check" { } "echo nhx check passed > $out"
)
