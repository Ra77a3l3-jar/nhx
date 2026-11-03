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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-pJUep6tGMdku3/jotV0j4w2g3TIh19YNTDvJNlZI3dQ=";
  };

  cargoHash = "sha256-ra3wFicUJ4yUnQ+kBRD7NleenNEbTkfZLw8JIeNYwOA=";

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
