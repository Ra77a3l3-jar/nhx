{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "devicons.hx";
  version = "0.1.0";
  cogName = "devicons";

  src = fetchFromGitHub {
    owner = "ivoronin";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-CbT3erUjBFn/WWzv1NFbkFE0B/uhofNhPTK5LlS8R+Q=";
  };

  doSteelCheck = true;

  meta = {
    description = "Nerd Font file icons and colors sourced from nvim-web-devicons for Helix Steel plugins";
    homepage = "https://github.com/ivoronin/devicons.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
