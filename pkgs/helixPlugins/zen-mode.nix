{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "zen-mode.hx";
  version = "0-unstable-2026-09-02";
  cogName = "zen-mode";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "notnmeyer";
    repo = finalAttrs.pname;
    rev = "f9fca83713c00e17ecad21edb6ac17c48c8de4bd";
    hash = "sha256-yE0sHytryj+nguEiEUvDbzpf42KKxWa0ZtuK2SNFSpM=";
  };

  meta = {
    description = "a zen-mode toggle for the steel-enabled helix fork, inspired by folke/zen-mode.nvim. centers the active window with even padding on both sides and hides the gutters.";
    homepage = "https://github.com/notnmeyer/zen-mode.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
