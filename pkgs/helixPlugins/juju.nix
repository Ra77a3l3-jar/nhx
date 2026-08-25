{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
  run-command,
  ui-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "juju";
  version = "0.3.16-alpha";
  updateVersion = "unstable";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-oVhcPkz7lLOBvlf6ztVO4kxLH2PynBXSQiPo7ZnIvZQ=";
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
