{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "splash.hx";
  version = "0-unstable-2026-03-08";
  cogName = "splash-hx";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = finalAttrs.pname;
    rev = "cd84a6a3d7d36e9076501c27bdb909447f12d60a";
    hash = "sha256-bxgG8ReEfD1b6j2MzHNNDIETqKf2NYN+eEqljpvctDk=";
  };

  meta = {
    description = "Splash screen plugin for helix";
    homepage = "https://github.com/mattwparas/splash.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
