{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  notify,
}:
buildHelixPlugin (finalAttrs: {
  pname = "oil.hx";
  version = "0-unstable-2026-11-01";
  cogName = "oil";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "8c5b8c8f5eea4a0232a838a88fdb1a072bd8bfee";
    hash = "sha256-FaF5NHSQyPWfwvBC/LS3w2rG4fvOqaj+pL76TLXRrIw=";
  };

  pluginDependencies = [
    notify
  ];

  meta = {
    description = "File Manager in a buffer for Helix editor";
    homepage = "https://github.com/Ra77a3l3-jar/oil.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
