{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "moka.hx";
  version = "0-unstable-2026-07-14";
  cogName = "moka";
  # updateVersion = "branch";
  updateVersion = "skip"; # [todo] update again after https://github.com/mattwparas/helix/pull/129 is merged and released in pkgs.steelix

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "d25ce9e302c3ef0cbad82ec6012582cbb66d440f";
    hash = "sha256-qV4MgOV3QJLQv8zCGvUSP5r8JOAWhx8jAUH+iKzHV9A=";
  };

  meta = {
    description = "A fully configurable statusline and bufferline for Helix.";
    homepage = "https://github.com/Ra77a3l3-jar/moka.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
