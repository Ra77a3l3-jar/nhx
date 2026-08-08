{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
  run-command,
  ui-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "juju";
  version = "0.3.13-alpha";
  updateVersion = "unstable";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-aZbf46a6QFUjuOva4+c8pt9I6wddUxQ6JlHKxS6QzA4=";
  };

  pluginDependencies = [
    run-command
    ui-utils
  ];

  doSteelCheck = true;

  meta = {
    description = "Juju is a git/jj interface for the Helix editor";
    homepage = "https://github.com/waddie/juju";
    license = lib.licenses.agpl3Only;
    # maintainers = with lib.maintainers; [ ];
  };
})
