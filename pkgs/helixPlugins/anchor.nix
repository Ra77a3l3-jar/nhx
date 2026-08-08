{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "anchor.hx";
  version = "0-unstable-2026-07-09";
  cogName = "anchor";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "739eb5c65afa69efaf415d5a51e1bd1889d57877";
    hash = "sha256-UlRO29Cw20gkOW+vGPhd5P6elXTWw4Qps0Ykkc1UPbM=";
  };

  meta = {
    description = "anchor.hx saves and restores your open buffers for Helix, scoped to the current workspace.";
    homepage = "https://github.com/Ra77a3l3-jar/anchor.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
