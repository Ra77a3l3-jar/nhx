{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  expansions,
  run-command,
  ui-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "run-shell.hx";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8M2mvHUUJcyKZJf2ALn9lRSjFx1VgET1JAjeY1DErU=";
  };

  pluginDependencies = [
    expansions
    run-command
    ui-utils
  ];

  doSteelCheck = true;
  preCheck = ''
    mv test tests
  '';

  meta = {
    description = "Blocking version of :run-shell-command, for Helix";
    homepage = "https://github.com/waddie/run-shell.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
