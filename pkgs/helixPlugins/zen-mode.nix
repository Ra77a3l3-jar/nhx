{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "zen-mode.hx";
  version = "0-unstable-2026-09-17";
  cogName = "zen-mode";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "notnmeyer";
    repo = finalAttrs.pname;
    rev = "ce69db0d6f2ebc2dc9dbcd8bd089d4a29f1c773a";
    hash = "sha256-Ne244Ekf1PBBsnx6Uq1hA4nvdTaQ4KDvjGhrdcWQw30=";
  };

  meta = {
    description = "a zen-mode toggle for the steel-enabled helix fork, inspired by folke/zen-mode.nvim. centers the active window with even padding on both sides and hides the gutters.";
    homepage = "https://github.com/notnmeyer/zen-mode.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
