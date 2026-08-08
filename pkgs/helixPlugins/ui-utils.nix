{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "ui-utils.hx";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-fgw6JoQZjnNl5nFk9ExF64nCOaTmtEPb3ulyxpekYaU=";
  };

  doSteelCheck = true;

  meta = {
    description = "Shared UI functions for my Helix plug-ins";
    homepage = "https://github.com/waddie/ui-utils.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
