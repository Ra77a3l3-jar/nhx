{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "scooter.hx";
  version = "0.3.0";
  cogName = "scooter";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-OZfJTZIj6k0NA5QcEnCTfcBwIoOrpRUwMFWMq4VJQVA=";
  };

  cargoHash = "sha256-2VxIgJS9YsZhgsYq6HdD3PpljARJWHrndOoFB8ckWDg=";

  doCheck = false;

  meta = {
    description = "Interactive find-and-replace Helix plugin";
    homepage = "https://github.com/thomasschafer/scooter.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
