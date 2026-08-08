{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "zen-mode.hx";
  version = "0-unstable-2026-07-12";
  cogName = "zen-mode";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "notnmeyer";
    repo = finalAttrs.pname;
    rev = "9513cf864c3d9e3c5e5d6a3315ff473f54070a16";
    hash = "sha256-d8eNa7r/FSyLLduEcwCAgpYvVnOv7TT7g9B8IEjCYqM=";
  };

  meta = {
    description = "a zen-mode toggle for the steel-enabled helix fork, inspired by folke/zen-mode.nvim. centers the active window with even padding on both sides and hides the gutters.";
    homepage = "https://github.com/notnmeyer/zen-mode.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
