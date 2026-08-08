{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  ts-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "extend-sibling.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-s6B7xdtPW3u3bYsskJ7A8q/aUKaDaPfK5mg9zNbxqa8=";
  };

  pluginDependencies = [
    ts-utils
  ];

  meta = {
    description = "Extend the selection by one tree-sitter sibling node, for Helix";
    homepage = "https://github.com/waddie/extend-sibling.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
