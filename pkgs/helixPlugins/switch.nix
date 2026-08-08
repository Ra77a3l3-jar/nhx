{
  buildHelixPlugin,
  fetchFromCodeberg,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "switch.hx";
  version = "0-unstable-2026-07-17";
  cogName = "switch";
  updateVersion = "branch";

  src = fetchFromCodeberg {
    owner = "gwid";
    repo = finalAttrs.pname;
    rev = "4c510493ea8420cfdc706b89cb4726aaec5df219";
    hash = "sha256-r0UNpR1treNOQquNRP6JYs6Pah+b+3/9/zLdSlQAR68=";
  };

  meta = {
    description = "Helix Plugin for switching between header and source files";
    homepage = "https://codeberg.org/gwid/switch.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
