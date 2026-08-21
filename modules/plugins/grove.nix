{ lib }:
let
  inherit (builtins) attrNames;
  inherit (lib)
    types
    mkOption
    optionals
    concatStringsSep
    ;
  s = import ../../lib/scheme.nix { inherit lib; };
  p = import ./lib.nix { inherit lib; };

  themeRoles = {
    paneBackground = "pane-background";
    visibleRow = "visible-row";
    pinnedAncestorRow = "pinned-ancestor-row";
    cursor = "cursor";
    activeFileBackground = "active-file-background";
    guidesForeground = "guides-foreground";
    activeFileMarkForeground = "active-file-mark-foreground";
    rail = "rail";
    filesystemErrorForeground = "filesystem-error-foreground";
    gitConflictForeground = "git-conflict-foreground";
    gitDeletedForeground = "git-deleted-foreground";
    gitModifiedForeground = "git-modified-foreground";
    gitCreatedForeground = "git-created-foreground";
    unsavedMarkForeground = "unsaved-mark-foreground";
  };

  themeOption =
    role:
    mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "grove-theme ${role}: Helix theme key or #f for the default.";
    };
in
p.mkPluginDescriptor {
  name = "grove";
  options = {
    icons = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "grove-start! #:icons: show file icons, requires a terminal font with Nerd Fonts 3.3 glyphs.";
    };
    guides = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "grove-start! #:guides: show ancestor traces and leaf marks.";
    };
    side = mkOption {
      type = types.nullOr (
        types.enum [
          "left"
          "right"
        ]
      );
      default = null;
      description = "grove-start! #:side: which side of the editor Grove docks to.";
    };
    width = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "grove-start! #:width: total width including the rail, 16 through 64.";
    };
    theme = mkOption {
      type = types.nullOr (
        types.submodule {
          options = lib.mapAttrs (role: kw: themeOption kw) themeRoles;
        }
      );
      default = null;
      description = "grove-theme role overrides; a role is a Helix theme key or null for the default.";
    };
  };
  render =
    cfg:
    let
      renderTheme =
        theme:
        s.call "grove-theme" (
          lib.concatLists (
            map (
              role:
              let
                value = theme.${role};
              in
              optionals (value != null) [
                (s.kw themeRoles.${role})
                (s.str value)
              ]
            ) (attrNames themeRoles)
          )
        );
    in
    if
      cfg.icons == null
      && cfg.guides == null
      && cfg.side == null
      && cfg.width == null
      && cfg.theme == null
    then
      ""
    else
      s.call "grove-start!" (
        optionals (cfg.icons != null) [
          (s.kw "icons")
          (s.bool cfg.icons)
        ]
        ++ optionals (cfg.guides != null) [
          (s.kw "guides")
          (s.bool cfg.guides)
        ]
        ++ optionals (cfg.side != null) [
          (s.kw "side")
          (s.sym cfg.side)
        ]
        ++ optionals (cfg.width != null) [
          (s.kw "width")
          (toString cfg.width)
        ]
        ++ optionals (cfg.theme != null) [
          (s.kw "theme")
          (renderTheme cfg.theme)
        ]
      );
}
