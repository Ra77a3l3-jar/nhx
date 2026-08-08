{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  ts-utils,
}:
buildHelixPlugin (finalAttrs: {
  pname = "paredit.hx";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-udEftBvVI3vYlmmMemuCb+oIKHVxnZIBdm1a5jQtVQo=";
  };

  pluginDependencies = [
    ts-utils
  ];

  meta = {
    description = "A paredit implementation for the Helix editor";
    homepage = "https://github.com/waddie/paredit.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
