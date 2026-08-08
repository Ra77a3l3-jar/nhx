{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "flash.hx";
  version = "0-unstable-2025-11-14";
  cogName = "flash";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "shybovycha";
    repo = finalAttrs.pname;
    rev = "94ec40289f80333f0430b97312137cc5cd4c4f24";
    hash = "sha256-yxKgzoAbwsAUSZ3f8cNoDjC2u9TFMbRWHeJFGeq7inQ=";
  };

  meta = {
    description = "Helix plugin to jump around like with flash.nvim";
    homepage = "https://github.com/shybovycha/flash.hx";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
