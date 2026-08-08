{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
}:
buildHelixPlugin (finalAttrs: {
  pname = "scopeline.hx";
  version = "0.1.0";
  cogName = "scopeline";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-tbOqWSF+dvqW84zaZ4oK5RPe6Euan4MafO+VHUktO4I=";
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
