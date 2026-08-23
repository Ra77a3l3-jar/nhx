{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
}:
buildHelixPlugin (finalAttrs: {
  pname = "scopeline.hx";
  version = "0.2.0-unstable-2026-08-23";
  cogName = "scopeline";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "6158e3eab8510565665c26de5b6e3bf258cb45d2";
    hash = "sha256-/tmUgJyrmuGClphe9ikv2C10SnkLypyPtTKWL0O/s1k=";
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
