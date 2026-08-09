# The moka statusline and bufferline.
{ lib }:
let
  inherit (builtins) attrNames toString;
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
  name = "moka";
  options = {
    transparent = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "moka configure, transparent background.";
    };
    rowOffset = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "moka configure, statusline row offset.";
    };
    modeColors = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            bg = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            fg = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        }
      );
      default = { };
      description = "Mode name to bg and fg colors, rendered into mode-colors.";
    };
    sections = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            align = mkOption {
              type = types.enum [
                "left"
                "center"
                "right"
              ];
              default = "left";
            };
            segments = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    kind = mkOption {
                      type = types.str;
                      description = "Registered moka segment kind, e.g. mode, file, git-branch, lsp, position.";
                    };
                    bubble = mkOption {
                      type = types.oneOf [
                        types.bool
                        (types.enum [
                          "angled"
                        ])
                      ];
                      default = false;
                      description = "true for round, angled for sharp, false for flat.";
                    };
                    coloredIcons = mkOption {
                      type = types.bool;
                      default = false;
                    };
                    bg = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };
                    fg = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };
                    gap = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                    };
                  };
                }
              );
              default = [ ];
            };
          };
        }
      );
      default = [ ];
      description = "Statusline sections rendered into moka configure.";
    };
    bufferline = mkOption {
      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to emit the moka bufferline configure and enable calls.";
          };
          active = mkOption {
            type = types.submodule {
              options = {
                bg = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                fg = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                bubble = mkOption {
                  type = types.bool;
                  default = false;
                };
              };
            };
            default = { };
          };
          inactive = mkOption {
            type = types.submodule {
              options = {
                bg = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                fg = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                bubble = mkOption {
                  type = types.bool;
                  default = false;
                };
              };
            };
            default = { };
          };
          gap = mkOption {
            type = types.int;
            default = 0;
          };
        };
      };
      default = { };
    };
  };
  render =
    cfg:
    let
      renderSegment =
        seg:
        s.call "moka-segment" (
          [ (s.sym seg.kind) ]
          ++ optionals (seg.bubble == true) [
            (s.kw "bubble?")
            (s.bool true)
          ]
          ++ optionals (seg.bubble == "angled") [
            (s.kw "bubble?")
            (s.sym "angled")
          ]
          ++ optionals (seg.bg != null) [
            (s.kw "bg")
            (s.str seg.bg)
          ]
          ++ optionals (seg.fg != null) [
            (s.kw "fg")
            (s.str seg.fg)
          ]
          ++ optionals (seg.gap != null) [
            (s.kw "gap")
            (toString seg.gap)
          ]
          ++ optionals seg.coloredIcons [
            (s.kw "colored-icons?")
            (s.bool true)
          ]
        );

      renderSection =
        sec:
        s.call "moka-section" [
          (s.list (map renderSegment sec.segments))
          (s.kw "align")
          (s.sym sec.align)
        ];

      renderColorHash =
        colors:
        s.hash (
          optionals (colors.bg != null) [
            (s.hashEntry (s.sym "bg") (s.str colors.bg))
          ]
          ++ optionals (colors.fg != null) [
            (s.hashEntry (s.sym "fg") (s.str colors.fg))
          ]
        );

      renderModeColors =
        modeColors:
        s.hash (
          map (mode: s.hashEntry (s.sym mode) (renderColorHash modeColors.${mode})) (attrNames modeColors)
        );

      renderConfigure = s.call "moka-configure!" (
        optionals (cfg.transparent == true) [
          (s.kw "transparent?")
          (s.bool true)
        ]
        ++ optionals (cfg.rowOffset != null) [
          (s.kw "row-offset")
          (toString cfg.rowOffset)
        ]
        ++ optionals (cfg.modeColors != { }) [
          (s.kw "mode-colors")
          (renderModeColors cfg.modeColors)
        ]
        ++ optionals (cfg.sections != [ ]) [
          (s.kw "sections")
          (s.list (map renderSection cfg.sections))
        ]
      );

      renderBufferStyle =
        st:
        s.call "moka-buffer-style" (
          optionals (st.bg != null) [
            (s.kw "bg")
            (s.str st.bg)
          ]
          ++ optionals (st.fg != null) [
            (s.kw "fg")
            (s.str st.fg)
          ]
          ++ optionals st.bubble [
            (s.kw "bubble?")
            (s.bool true)
          ]
        );

      renderBufferline = s.call "moka-bufferline-configure!" (
        optionals (cfg.bufferline.active != { }) [
          (s.kw "active")
          (renderBufferStyle cfg.bufferline.active)
        ]
        ++ optionals (cfg.bufferline.inactive != { }) [
          (s.kw "inactive")
          (renderBufferStyle cfg.bufferline.inactive)
        ]
        ++ [
          (s.kw "gap")
          (toString cfg.bufferline.gap)
        ]
      );
    in
    concatStringsSep "\n" (
      [
        renderConfigure
        (s.call "moka-enable!" [ ])
      ]
      ++ optionals cfg.bufferline.enable [
        renderBufferline
        (s.call "moka-bufferline-enable!" [ ])
      ]
    );
}
