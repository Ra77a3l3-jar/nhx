{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "moka.hx";
  version = "0-unstable-2026-08-23";
  cogName = "moka";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "22059191425b7dbefa44060048bede3fe8676933";
    hash = "sha256-5312U/diMFsU/XRdF91aLRPLLuK9+iEHJSJPvmsuHV4=";
  };

  meta = {
    description = "A fully configurable statusline and bufferline for Helix.";
    homepage = "https://github.com/Ra77a3l3-jar/moka.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
