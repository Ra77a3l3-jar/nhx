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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-Og7dKyn1fWqkxNcEdGwTZOWMTE8BuWpiEOdMhguz0kA=";
  };

  cargoHash = "sha256-haQBkL9g3z4CY7aeWSGuqZLzmfrupISc1kHrhSR5dik=";

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
