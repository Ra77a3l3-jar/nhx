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

      renderConfigure = s.call "moka-configure!" (
        optionals (cfg.sections != [ ]) [
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
