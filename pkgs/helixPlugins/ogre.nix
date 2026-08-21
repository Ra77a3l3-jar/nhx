{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "ogre.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-AxMuF/BUnvw8vsxglnLGzCLP627JVgKFcrbFq1+2G8Q=";
  };

  doSteelCheck = true;

  meta = {
    description = "Restore original group-wise rotate selection commands for Helix";
    homepage = "https://github.com/waddie/ogre.hx";
    license = lib.licenses.agpl3Plus;
    # maintainers = with lib.maintainers; [ ];
  };
})
