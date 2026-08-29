{ lib }:
let
  inherit (lib)
    types
    mkOption
    optionals
    concatStringsSep
    ;
  s = import ../../lib/scheme.nix { inherit lib; };
  p = import ./lib.nix { inherit lib; };
in
p.mkPluginDescriptor {
  name = "forest";
  options = {
    style = mkOption {
      type = types.enum [
        "snacks"
        "mini"
      ];
      default = "snacks";
      description = "forest set style, snacks or mini.";
    };
    position = mkOption {
      type = types.enum [
        "left"
        "right"
      ];
      default = "left";
    };
    ignore = mkOption {
      type = types.listOf types.str;
      default = [
        ".git"
        "target"
        ".cache"
        "pycache"
      ];
      description = "Entry names always hidden.";
    };
    sidebarBg = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            focused = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            unfocused = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        }
      );
      default = null;
      description = "Sidebar background per focus state.";
    };
    circularKeybinds = mkOption {
      type = types.bool;
      default = false;
      description = "Snacks only. Wrap j/k inside the current folder and use h/l to enter or leave.";
    };
    searchColor = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            focused = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            unfocused = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            always = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            followFocus = mkOption {
              type = types.nullOr types.bool;
              default = null;
            };
          };
        }
      );
      default = null;
      description = "Search box outline color.";
    };
  };
  render =
    cfg:
    let
      colorKwArgs =
        colors:
        optionals (colors.focused != null) [
          (s.kw "focused")
          (s.str colors.focused)
        ]
        ++ optionals (colors.unfocused != null) [
          (s.kw "unfocused")
          (s.str colors.unfocused)
        ];
    in
    concatStringsSep "\n" (
      lib.optional (cfg.sidebarBg != null) (s.call "forest-set-sidebar-bg!" (colorKwArgs cfg.sidebarBg))
      ++ lib.optional (cfg.searchColor != null) (
        s.call "forest-set-search-color!" (
          colorKwArgs cfg.searchColor
          ++ optionals (cfg.searchColor.always != null) [
            (s.kw "always")
            (s.str cfg.searchColor.always)
          ]
          ++ optionals (cfg.searchColor.followFocus != null) [
            (s.kw "follow-focus?")
            (s.bool cfg.searchColor.followFocus)
          ]
        )
      )
      ++ lib.optional cfg.circularKeybinds (s.call "forest-snack-circular-keybinds" [ (s.bool true) ])
      ++ [
        (s.call "forest-set-style!" [ (s.sym cfg.style) ])
        (s.call "forest-configure!" (
          [ (s.sym cfg.position) ]
          ++ optionals (cfg.ignore != [ ]) [
            (s.kw "ignore")
            (s.list (map s.str cfg.ignore))
          ]
        ))
      ]
    );
}
