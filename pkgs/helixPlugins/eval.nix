{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  repl-ui,
}:
buildHelixPlugin (finalAttrs: {
  pname = "eval.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-KI46BgDUEtJ2JRVcW7mk6zNobGk4I5TAKYEfNPAI+Us=";
  };

  pluginDependencies = [
    repl-ui
  ];

  meta = {
    description = "Helix REPL scratch buffer for eval-string output";
    homepage = "https://github.com/waddie/eval.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
