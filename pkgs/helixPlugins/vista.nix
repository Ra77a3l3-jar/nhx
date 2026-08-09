{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
}:

buildHelixPlugin (finalAttrs: {
  pname = "vista.hx";
  version = "0-unstable-2026-07-30";
  cogName = "vista";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "fd53b347641c872c73acd563c07c60eb7316ae2b";
    hash = "sha256-K2M/a6CpWjtaYaGBOYSZZ2ublHSslb7zkvelHbCsCUo=";
  };

  pluginDependencies = [
    glyph
  ];

  meta = {
    description = "In-editor markdown rendering for Helix.";
    homepage = "https://github.com/Ra77a3l3-jar/vista.hx";
    license = lib.licenses.mit;
  };
})
