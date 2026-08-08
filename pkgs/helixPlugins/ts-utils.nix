{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "ts-utils.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-xsf6bNJIyPKdhB+zJkRsnjoaUy1dR39BXPB3/DLD5oc=";
  };

  meta = {
    description = "Helix Steel helper functions for tree-sitter traversal";
    homepage = "https://github.com/waddie/ts-utils.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
