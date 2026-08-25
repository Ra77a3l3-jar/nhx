{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  ui-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "previously.hx";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-5gG5+pvgEHp5rCP+0KBWeP+BXZ5aEDL2/UU5CLX0RhQ=";
  };

  pluginDependencies = [
    ui-utils
  ];

  doSteelCheck = true;

  meta = {
    description = "Helix register history for yanks, commands and searches";
    homepage = "https://github.com/waddie/previously.hx";
    license = lib.licenses.agpl3Only;
    # maintainers = with lib.maintainers; [ ];
  };
})
