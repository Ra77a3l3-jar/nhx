{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "scooter.hx";
  version = "0.2.0";
  cogName = "scooter";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-pxvD4yJ1qtS4lUpJIIJZdYnDEYY415aZ03ufBoIt6hQ=";
  };

  cargoHash = "sha256-QQ9ISkhRUsp/FNiMHSzZTfWmpnU7AD84bdo3GkIbjOo=";

  doCheck = false;

  meta = {
    description = "Interactive find-and-replace Helix plugin";
    homepage = "https://github.com/thomasschafer/scooter.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
