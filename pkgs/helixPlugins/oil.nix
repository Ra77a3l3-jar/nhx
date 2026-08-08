{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  notify,
}:
buildHelixPlugin (finalAttrs: {
  pname = "oil.hx";
  version = "0-unstable-2026-07-29";
  cogName = "oil";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "fdd38520dc041d4314a7c5bc13520195b7f06cfa";
    hash = "sha256-cMpKLYVh5RkrbmKbigYdAjrF8J1wq6KxOfXoZ4AHLeE=";
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
