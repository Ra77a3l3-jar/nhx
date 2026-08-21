{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  run-command,
}:
buildHelixPlugin (finalAttrs: {
  pname = "expansions.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-k2382C7R1ug1GOQ5olNgPw4yv7GfS0eng6wVCxcOfcM=";
  };

  pluginDependencies = [
    run-command
  ];

  doSteelCheck = true;
  preCheck = ''
    mv test tests
  '';

  meta = {
    description = "Resolve standard Helix command line expansions in Steel";
    homepage = "https://github.com/waddie/expansions.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
