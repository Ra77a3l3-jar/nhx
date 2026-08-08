{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "file-tree.hx";
  version = "0-unstable-2026-03-08";
  cogName = "file-tree-hx";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = finalAttrs.pname;
    rev = "e84e92f6ab62d4436768d70639ca0ba7ec72c073";
    hash = "sha256-AHvL0wQJqtaPDJpR+XByFWI/q9NNZfNdpMt4XXC4NMY=";
  };

  meta = {
    description = "File tree plugin for helix";
    homepage = "https://github.com/mattwparas/file-tree.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
