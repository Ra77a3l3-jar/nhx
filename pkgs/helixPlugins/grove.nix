{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  devicons,
}:
buildHelixPlugin (finalAttrs: {
  pname = "grove.hx";
  version = "0-unstable-2026-08-20";
  cogName = "grove";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "ivoronin";
    repo = finalAttrs.pname;
    rev = "5af0f5e7f37b98009f040417507bd72b9905b201";
    hash = "sha256-pqwGWLfDB6RT8/H47ndoimyxmeMAm34UIwi/0Fibq7c=";
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
