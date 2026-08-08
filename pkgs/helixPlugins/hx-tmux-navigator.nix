{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "hx-tmux-navigator";
  version = "0-unstable-2025-08-11";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "piotrkwarcinski";
    repo = finalAttrs.pname;
    rev = "e6f28c5c7e4182a003e9e0bdddbec6c6284ec621";
    hash = "sha256-5NK318B17iJZ81D5svLGnAy/ke8zW5nfEQouzdynlp0=";
  };

  meta = {
    description = "Seamlessly navigate between tmux panes and helix splits.";
    homepage = "https://github.com/piotrkwarcinski/hx-tmux-navigator";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
