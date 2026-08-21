{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  ui-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "previously.hx";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6Of6gbRY2Ka5W+cbfWb23jlvFwWnOFOlDNjnC8/EAY=";
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
