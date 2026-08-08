{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  ts-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "select-ts.hx";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-4qE9GECqYvxPAPa62zTCT3r3i3TFqD0csYJt4tQZKWs=";
  };

  pluginDependencies = [
    ts-utils
  ];

  meta = {
    description = "Create selections in Helix with an ad hoc tree-sitter query";
    homepage = "https://github.com/waddie/select-ts.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
