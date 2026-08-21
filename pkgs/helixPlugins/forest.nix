{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
  notify,
}:
buildHelixPlugin (finalAttrs: {
  pname = "forest.hx";
  version = "0-unstable-2026-08-08";
  cogName = "forest";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "40e5aadf64b652534978a644dfc8536d95f7cabd";
    hash = "sha256-oclnuR77thCeZh/A/qP3xfUuO6hkuAI4eVgEgGUeEjA=";
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
