{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
}:
buildHelixPlugin (finalAttrs: {
  pname = "scopeline.hx";
  version = "0-unstable-2026-08-22";
  cogName = "scopeline";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "a34512b17b35d487f8c88c488bc0086dccb4b21b";
    hash = "sha256-fdFOBNjQsLZoV007KssI4H7bC7gYWWuq1ddO8kdSR/8=";
  };

  pluginDependencies = [
    glyph
  ];

  postInstall = ''
    cp -r languages $out/languages
  '';

  meta = {
    description = "breadcrumb plugin for Helix editor";
    homepage = "https://github.com/Ra77a3l3-jar/scopeline.hx";
    license = lib.licenses.mit;
  };
})
