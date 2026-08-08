{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "smooth-scroll.hx";
  version = "0.1.0-unstable-2025-11-13";
  cogName = "smooth-scroll";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = finalAttrs.pname;
    rev = "1ed8b088e465fb139389c36ad158ba4a2d9e1bbc";
    hash = "sha256-4lxGZrT4cEcg3jqae3uJGGGCSy4WeVZeJ0hIApMb7jY=";
  };

  meta = {
    description = "Smooth scrolling Helix plugin";
    homepage = "https://github.com/thomasschafer/smooth-scroll.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
