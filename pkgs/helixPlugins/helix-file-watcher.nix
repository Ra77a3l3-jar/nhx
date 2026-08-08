{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "helix-file-watcher";
  version = "0-unstable-2026-08-02";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = finalAttrs.pname;
    rev = "ea1ad0dfc1f5f806eed837baf01ef0263cff1be0";
    hash = "sha256-O8qkQX+yYjSCtnZ59jfVJdPYc7XTvMpBw3gXtWtjfAk=";
  };

  cargoHash = "sha256-RhxKQSydcY48/aWZGPbJe6pFrKptynMV35BQSD16tXo=";

  meta = {
    description = "Helix file watcher plugin";
    homepage = "https://github.com/mattwparas/helix-file-watcher";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
