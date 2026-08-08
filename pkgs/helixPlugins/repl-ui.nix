{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "repl-ui.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+pYS0AIUrwZfxHiAMZOdn/7PSaQ2g0kI2UTPBLhkGg=";
  };

  meta = {
    description = "Shared library for REPL-style plugins.";
    homepage = "https://github.com/waddie/repl-ui.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
