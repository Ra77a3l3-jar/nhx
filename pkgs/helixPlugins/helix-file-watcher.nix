{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "helix-file-watcher";
  version = "0-unstable-2026-08-09";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = finalAttrs.pname;
    rev = "8cd0726da47be4a1011c3246ff308c1dfefda9d1";
    hash = "sha256-auqS4wcJGCUJXzRVj4neQLJnqErvty3+3shfq5DU/pg=";
  };

  cargoHash = "sha256-RhxKQSydcY48/aWZGPbJe6pFrKptynMV35BQSD16tXo=";

  meta = {
    description = "Helix file watcher plugin";
    homepage = "https://github.com/mattwparas/helix-file-watcher";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
