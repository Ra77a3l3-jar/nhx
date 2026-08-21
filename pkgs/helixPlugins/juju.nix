{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
  run-command,
  ui-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "juju";
  version = "0.3.14-alpha";
  updateVersion = "unstable";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-yhE9fFN5gr1D3G7aDZJEAl+SfU9ac6C07vZxq648Ffw=";
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
