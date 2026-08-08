{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "switcheroo.hx";
  version = "0-unstable-2025-06-28";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "godalming123";
    repo = finalAttrs.pname;
    rev = "8b834db5d068d941ed8f8e1e84255d73b9cfd193";
    hash = "sha256-WHfIA089jeW63gI31p0oMauT0h+eaULw4h84tbfdaV4=";
  };

  meta = {
    description = "A helix plugin to switch between `.cpp` and `.h` files with the same base name.";
    homepage = "https://github.com/godalming123/switcheroo.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
