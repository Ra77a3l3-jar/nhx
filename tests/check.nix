{
  runCommand,
  lib,
  pkgs,
}:
let
  nhxModule = import ../modules;

  fileType = lib.types.attrsOf (
    lib.types.submodule {
      options.text = lib.mkOption { type = lib.types.str; };
      options.source = lib.mkOption { type = lib.types.path; };
    }
  );

  # minimal home stub with nhx needed settings
  homeStub = { lib }: {
    options.programs.helix =
      (lib.genAttrs [
        "enable"
        "package"
        "settings"
        "languages"
      ] (_: lib.mkOption { type = lib.types.anything; }))
      // {
        defaultEditor = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };
        themes = lib.mkOption {
          type = lib.types.attrsOf (pkgs.formats.toml { }).type;
          default = { };
        };
        ignores = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

    options.xdg.configFile = lib.mkOption {
      type = fileType;
      default = { };
    };

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
        type = fileType;
        default = { };
      };
    };
  };

  result = lib.evalModules {
    modules = [
      { config._module.args = { inherit lib pkgs; }; }
      (homeStub { inherit lib; })

      # Package and name entries are installed and loaded by default.
      ({ helixPlugins, ... }: {
        programs.nhx.plugins = with helixPlugins; [
          scooter
          trail
          "anchor"
        ];
      })

      {
        _file = ./check.nix;
        programs.nhx = {
          enable = true;
          defaultEditor = true;
          extraConfig = "# extra configuration from nhx";
          extraPackages = [ pkgs.ripgrep ];
          themes.custom.inherits = "base16_default";
          ignores = [ ".cache/" ];

          settings = {
            theme = "catppuccin_mocha";
            editor.line-number = "relative";
          };

          languages = {
            language = [
              {
                name = "scheme";
                scope = "source.scheme";
                file-types = [ "scm" ];
              }
            ];
          };

          coreRequires = [ ./helix/treesitter.scm ];

          steel = {
            enable = true;

            extra = ''
              (when (equal? (command-line) '''("hx"))
                (show-splash))
            '';
          };
        };

        programs.nhx.plugins.forest = {
          config = {
            style = "snacks";
            position = "left";
          };
        };

        programs.nhx.plugins.moka = {
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
          config.render = "minimal";
          extra = ''
            (notify-config 'timeout 5000)
          '';
        };

        programs.nhx.plugins.oil = {
          config = {
            showDotfiles = true;
            keymaps.normal = {
              "ret" = ":oil-enter";
            };
          };
        };

        # An empty entry is enabled too; an explicit opt-out is still installed.
        programs.nhx.plugins.devicons = { };
        programs.nhx.plugins.trail = {
          enable = false;
          extra = ''(error "disabled-trail-must-not-run")'';
        };
      }

      # Aliases must preserve upstream defaults and merge with other modules.
      {
        programs.helix = {
          defaultEditor = lib.mkDefault false;
          extraConfig = "# extra configuration from another module";
          extraPackages = [ pkgs.fd ];
          themes.external.inherits = "base16_default";
          ignores = [ ".direnv/" ];
        };
      }

      nhxModule
      { home.homeDirectory = "/home/user"; }
    ];
  };

  files = result.config.home.file;
  configFiles = result.config.xdg.configFile;
  helix = result.config.programs.helix;
  initScm = configFiles."helix/init.scm".text;

  # check generated init.scm checked before the build
  assertHas =
    expected:
    if lib.hasInfix expected initScm then
      true
    else
      throw "nhx check: init.scm does not contain: ${expected}";

  assertLacks =
    unexpected:
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
    (assertHas "(require \"scooter/scooter.scm\")")
    (assertHas "(require \"anchor/anchor.scm\")")
    (assertHas "(require \"devicons/devicons.scm\")")
    (assertLacks "trail")
    (assertLacks "disabled-trail-must-not-run")
    (assertLacks "(require \"glyph/glyph.scm\")")

    # config check
    (assertHas "(forest-set-style! 'snacks)")
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

    # settings are forwarded to programs.helix
    (helix.enable || throw "nhx check: programs.helix.enable not enabled")
    (
      helix.package.pname == pkgs.steelix.pname
      || throw "nhx check: programs.helix.package is not steelix"
    )
    (
      helix.settings.theme == "catppuccin_mocha"
      || throw "nhx check: settings not forwarded to programs.helix"
    )
    (helix.languages.language != [ ] || throw "nhx check: languages not forwarded to programs.helix")

    # Upstream aliases keep the user configuration under programs.nhx and
    # preserve merging with definitions from integrations using programs.helix.
    (helix.defaultEditor || throw "nhx check: defaultEditor alias lost to upstream default")
    (
      lib.all (text: lib.hasInfix text helix.extraConfig) [
        "# extra configuration from nhx"
        "# extra configuration from another module"
      ]
      || throw "nhx check: extraConfig definitions were not merged"
    )
    (
      lib.all (package: builtins.elem package helix.extraPackages) [
        pkgs.ripgrep
        pkgs.fd
      ]
      || throw "nhx check: extraPackages definitions were not merged"
    )
    (
      helix.themes.custom.inherits == "base16_default"
      && helix.themes.external.inherits == "base16_default"
      || throw "nhx check: themes definitions were not merged"
    )
    (
      lib.all (pattern: builtins.elem pattern helix.ignores) [
        ".cache/"
        ".direnv/"
      ]
      || throw "nhx check: ignores definitions were not merged"
    )
  ];

  # generated file
  expectedFiles = [
    "helix/init.scm"
  ];

  # installed plugins
  expectedCogs = map (c: ".local/share/steel/cogs/${c}") [
    "anchor"
    "devicons"
    "forest"
    "glyph"
    "moka"
    "notify"
    "oil"
    "scooter"
    "trail"
  ];

  missingFiles = lib.subtractLists (builtins.attrNames configFiles) expectedFiles;

  installedCogs = builtins.attrNames (
    lib.filterAttrs (n: v: lib.hasPrefix ".local/share/steel/cogs/" n) files
  );

  missingCogs = lib.subtractLists installedCogs expectedCogs;
in
# deepSeq forces the assert thunks so the asserts actually run
builtins.seq (builtins.deepSeq asserts asserts) (
  if missingFiles != [ ] then
    throw "nhx check: missing files: ${lib.concatStringsSep ", " missingFiles}"
  else if missingCogs != [ ] then
    throw "nhx check: missing cogs: ${lib.concatStringsSep ", " missingCogs}"
  else
    runCommand "nhx-check" { } "echo nhx check passed > $out"
)
