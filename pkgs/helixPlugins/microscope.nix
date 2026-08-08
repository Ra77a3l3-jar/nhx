{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "microscope.hx";
  version = "0-unstable-2026-03-28";
  cogName = "microscope";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "chuwy";
    repo = "microscope.hx";
    rev = "7fe4e60f0c4fb715118591c71ed0a82b111f07a8";
    hash = "sha256-j1sNxa19bbskizNSzTYDCSXImfOkXMOEdb7hGg5tuxQ=";
  };

  meta = {
    description = "Customizable pickers for Helix editor";
    homepage = "https://github.com/chuwy/microscope.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
