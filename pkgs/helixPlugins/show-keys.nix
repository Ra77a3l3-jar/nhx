{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "showkeys.hx";
  version = "0-unstable-2025-09-20";
  cogName = "showkeys";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "HeitorAugustoLN";
    repo = finalAttrs.pname;
    rev = "5996e1ab8df03ac5a708bc569a4bed3791af60bf";
    hash = "sha256-9oLpZKJ6ZStwr4ijRI2XlUP8fvlR2Boy3qVPW4+YIgQ=";
  };

  meta = {
    description = "A Helix plugin to display pressed keys on screen";
    homepage = "https://github.com/HeitorAugustoLN/showkeys.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
