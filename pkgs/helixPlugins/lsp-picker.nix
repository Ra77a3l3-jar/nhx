{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "lsp-picker.hx";
  version = "0-unstable-2026-07-02";
  cogName = "lsp-picker";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "brnosouza";
    repo = finalAttrs.pname;
    rev = "61ce6e3a90c2725ca2fc7539b9d76d83533e7c59";
    hash = "sha256-mecqTw37Dj+cf3SPdhbFH6y21hRP94rMsdPjMgOPPDQ=";
  };

  meta = {
    description = "A Helix plugin (Steel/Scheme) that opens a floating picker to manage LSP servers attached to the current buffer.";
    homepage = "https://github.com/brnosouza/lsp-picker.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
