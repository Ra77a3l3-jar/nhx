{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "matte.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-633dAUhiiK8FM2xUFKoVMYdW4D7hzcQ1t9R7/dFarTE=";
  };

  doSteelCheck = true;

  meta = {
    description = "Zen mode for Helix: centre a buffer, zoom and restore splits";
    homepage = "https://github.com/waddie/matte.hx";
    license = lib.licenses.agpl3Only;
    # maintainers = with lib.maintainers; [ ];
  };
})
