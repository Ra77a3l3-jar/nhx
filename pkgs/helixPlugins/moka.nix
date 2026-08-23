{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "moka.hx";
  version = "0-unstable-2026-08-23";
  cogName = "moka";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "b80ac0497833754e21ea9d2d4abb094c706eda82";
    hash = "sha256-6LjdN6vVrYUshKM+c91pHDRXxRAc6oZAvumKUtwmhWU=";
  };

  meta = {
    description = "A fully configurable statusline and bufferline for Helix.";
    homepage = "https://github.com/Ra77a3l3-jar/moka.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
