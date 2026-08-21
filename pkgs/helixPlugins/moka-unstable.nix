{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
}:

buildHelixPlugin (finalAttrs: {
  pname = "moka.hx";
  version = "0-unstable-2026-08-21";
  cogName = "moka";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "f914abbf3f5e69b828dc9ef3ceb2066ac8f442d8";
    hash = "sha256-uKgUTb40gI6ro+7K0Y0rBztgcA14qcHPkbTaW2Sx6Zg=";
  };

  pluginDependencies = [
    glyph
  ];

  meta = {
    description = "A fully configurable statusline and bufferline for Helix (unstable branch).";
    homepage = "https://github.com/Ra77a3l3-jar/moka.hx";
    license = lib.licenses.mit;
  };
})
