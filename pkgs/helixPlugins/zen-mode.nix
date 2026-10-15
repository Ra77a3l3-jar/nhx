{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "zen-mode.hx";
  version = "0-unstable-2026-10-14";
  cogName = "zen-mode";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "notnmeyer";
    repo = finalAttrs.pname;
    rev = "d04b50ac9167faa9c5ead9a69a32327e8af15f41";
    hash = "sha256-BW+0NuUK86LPZyC6CJdaBk7JwHCEBlShuco/pPzzfNg=";
  };

  meta = {
    description = "a zen-mode toggle for the steel-enabled helix fork, inspired by folke/zen-mode.nvim. centers the active window with even padding on both sides and hides the gutters.";
    homepage = "https://github.com/notnmeyer/zen-mode.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
