{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "fake-warp.hx";
  version = "0-unstable-2026-04-13";
  cogName = "fake-warp";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Xerxes-2";
    repo = finalAttrs.pname;
    rev = "542214f6359880c70663e3e58e0d1c5fda10d328";
    hash = "sha256-Db/YOBfALu4R2KuyXQxl7L2AQcJdeF37ykGt7l9WziA=";
  };

  meta = {
    description = "Helix Steel plugin to trigger terminal cursor animations for block cursors";
    homepage = "https://github.com/Xerxes-2/fake-warp.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
