{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  devicons,
}:
buildHelixPlugin (finalAttrs: {
  pname = "grove.hx";
  version = "0-unstable-2026-09-15";
  cogName = "grove";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "ivoronin";
    repo = finalAttrs.pname;
    rev = "82b8aa936a535644bb724d1319b9a0217d21b0c4";
    hash = "sha256-6YnT/sWGRYQdyrOmpZFW4fGtnWYHGgqTcDtSCdqbIq0=";
  };

  pluginDependencies = [
    devicons
  ];

  meta = {
    description = "A docked file tree for Helix, inspired by Zed's project panel";
    homepage = "https://github.com/ivoronin/grove.hx";
    # license = null; # no license file in upstream repo
    # maintainers = with lib.maintainers; [ ];
  };
})
