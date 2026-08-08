{
  buildHelixPlugin,
  fetchFromCodeberg,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "modeline.hx";
  version = "0-unstable-2026-07-25";
  cogName = "modeline";
  updateVersion = "branch";

  src = fetchFromCodeberg {
    owner = "gwid";
    repo = finalAttrs.pname;
    rev = "f66a38eec144c28a1cf8aa5369aaaa20fa3bac1d";
    hash = "sha256-HSmC11yi1W9G1y2OOhKmPE2pSjq8yxVgtGrqarjX80c=";
  };

  meta = {
    description = "Helix Plugin for modeline";
    homepage = "https://codeberg.org/gwid/modeline.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
