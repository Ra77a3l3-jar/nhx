{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
}:

buildHelixPlugin (finalAttrs: {
  pname = "moka.hx";
  version = "0-unstable-2026-07-21";
  cogName = "moka";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "493a0e64b7afd67eb02a37a8472984a215b745ce";
    hash = "sha256-yXcr5rbm4HF2d0ISuRWrrNDcTK1EGSyTv82JlJNfrOc=";
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
