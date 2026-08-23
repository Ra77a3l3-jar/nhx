{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
  notify,
}:
buildHelixPlugin (finalAttrs: {
  pname = "forest.hx";
  version = "0.1.1";
  cogName = "forest";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-MWyZHv01vC8w3YF3LMNb8r+NiN8a1JLSUPIlyPwuuVI=";
  };

  pluginDependencies = [
    glyph
    notify
  ];

  meta = {
    description = "A file explorer tree for Helix";
    homepage = "https://github.com/Ra77a3l3-jar/forest.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
