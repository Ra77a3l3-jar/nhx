{
  buildHelixPlugin,
  fetchFromCodeberg,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "switch.hx";
  version = "0-unstable-2026-08-19";
  cogName = "switch";
  updateVersion = "branch";

  src = fetchFromCodeberg {
    owner = "gwid";
    repo = finalAttrs.pname;
    rev = "dca021f353b308516558e91a478cff658d6064ee";
    hash = "sha256-fWvesLfTuBgBsBffcO2kPH4KYr92C4/zkTLsyBpXyqo=";
  };

  meta = {
    description = "Helix Plugin for switching between header and source files";
    homepage = "https://codeberg.org/gwid/switch.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
