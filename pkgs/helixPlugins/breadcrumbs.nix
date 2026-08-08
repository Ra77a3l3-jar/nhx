{
  buildHelixPlugin,
  fetchFromCodeberg,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "breadcrumbs.hx";
  version = "0-unstable-2026-02-15";
  cogName = "breadcrumbs";
  updateVersion = "branch";

  src = fetchFromCodeberg {
    owner = "gwid";
    repo = finalAttrs.pname;
    rev = "989886b1ab0485c3501ac3a716475a64a4191d9c";
    hash = "sha256-xzaUZFRv2hKJKru5GAhFA8kmy2hosZDPNPvcK/UKwxs=";
  };

  meta = {
    description = "Helix Plugin for breadcrumbs/context";
    homepage = "https://codeberg.org/gwid/breadcrumbs.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
