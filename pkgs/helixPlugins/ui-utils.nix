{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "ui-utils.hx";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-rl/I8rkSVu1sCx3FqEwKn3X6gPs8R24352mRXCDBJ18=";
  };

  doSteelCheck = true;

  meta = {
    description = "Shared UI functions for my Helix plug-ins";
    homepage = "https://github.com/waddie/ui-utils.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
