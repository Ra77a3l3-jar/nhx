{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  notify,
}:
buildHelixPlugin (finalAttrs: {
  pname = "oil.hx";
  version = "0-unstable-2026-09-01";
  cogName = "oil";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "6a6a3f9d93307642f2e08ab5dd4b06f6ecd210e2";
    hash = "sha256-JP/GU2FyJ0YXOSfod1nDbLZ+VbL+bZxtIGWjLUk4C/w=";
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
