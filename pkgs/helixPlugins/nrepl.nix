{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,

  repl-ui,
  run-command,
  ui-utils,
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "nrepl.hx";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-+CPcPB+/76ojJNnYaH5n/U4Mye7zdzPbVlWvUtajWBE=";
  };

  cargoHash = "sha256-eRX0kwz2XLc5suGhzD3yYpykEePgfVSeduEISg0m5ms=";

  pluginDependencies = [
    repl-ui
    run-command
    ui-utils
  ];

  doSteelCheck = true;

  meta = {
    description = "An nREPL client plugin for the Helix editor";
    homepage = "https://github.com/waddie/nrepl.hx";
    license = lib.licenses.agpl3Plus;
    # maintainers = with lib.maintainers; [ ];
  };
})
