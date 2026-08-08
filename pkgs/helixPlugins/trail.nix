{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "trail.hx";
  version = "0-unstable-2026-07-27";
  cogName = "trail";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "d586825e577b9bfa1303fab79bc1fcde4aef93f8";
    hash = "sha256-hh6cQh6GpOb5irHHaDrGqxu1wLReajEQrwQtFxLxtM4=";
  };

  meta = {
    description = "recent project picker for Helix";
    homepage = "https://github.com/Ra77a3l3-jar/trail.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
