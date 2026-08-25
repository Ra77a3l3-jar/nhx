{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "ui-utils.hx";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-DrWhnO0NWKHEvXoPuaySdhb3MtJleSGvmROdLsO8IiU=";
  };

  doSteelCheck = true;

  meta = {
    description = "Shared UI functions for my Helix plug-ins";
    homepage = "https://github.com/waddie/ui-utils.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
