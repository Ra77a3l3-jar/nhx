{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  ts-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "extend-sibling.hx";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-D/MDRe1oex4T0wmYAxSeNYvA3iAj9au6HOeJqTC5c4Y=";
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
