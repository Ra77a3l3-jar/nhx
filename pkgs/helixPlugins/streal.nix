{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "streal.hx";
  version = "0.3.0-unstable-2026-02-01";
  cogName = "streal";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "gllms";
    repo = finalAttrs.pname;
    rev = "9c9974da4fd7b01eda172f95aa6e3445345bb30d";
    hash = "sha256-0Ft7PjFFOpOM5vuPQ0vcEM05/2GZkyWbqNh8p/iEdds=";
  };

  meta = {
    description = "Helix plugin to bookmark files and quickly switch between them";
    homepage = "https://github.com/gllms/streal.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
