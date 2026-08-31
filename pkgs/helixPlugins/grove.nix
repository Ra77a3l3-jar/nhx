{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  devicons,
}:
buildHelixPlugin (finalAttrs: {
  pname = "grove.hx";
  version = "0-unstable-2026-08-30";
  cogName = "grove";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "ivoronin";
    repo = finalAttrs.pname;
    rev = "50a64de161ca52e7ed5745335764fab2eded3c7d";
    hash = "sha256-mDwKzRCTA9Z7KATzWLMj/XGdkMJrh/weZ4717Ma5dwE=";
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
