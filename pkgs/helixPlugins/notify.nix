{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "notify.hx";
  version = "0-unstable-2026-03-30";
  cogName = "notify";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "chuwy";
    repo = finalAttrs.pname;
    rev = "0a328073e6d3e5041346374ae747c275ab8ce746";
    hash = "sha256-shKUVnJw2j0yYO+mTHsKie+d1VrJGWDTRul+PTpqlhs=";
  };

  meta = {
    description = "A notification engine for Helix";
    homepage = "https://github.com/chuwy/notify.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [  ];
  };
})
