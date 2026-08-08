{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "vim.hx";
  version = "0-unstable-2026-03-08";
  cogName = "vim-hx";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = finalAttrs.pname;
    rev = "43f9c7fd26216c15fdf2455ac19ff0441a272876";
    hash = "sha256-ITssLSJGdhwlt7JBZKFaFrxwme9HyFOY6NrGpIY+1q4=";
  };

  meta = {
    description = "Plugin to provide vim bindings for helix";
    homepage = "https://github.com/mattwparas/vim.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
