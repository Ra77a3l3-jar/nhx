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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-GNe24bQoMR2AKnoEhdoIjJbv9uBOx5lLw6olbhUScy4=";
  };

  cargoHash = "sha256-F/UgEFSpkpfqdlMB3J1/ykG+t8HqhmuD/aRFEv9NPbc=";

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
