{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  glyph,
  notify,
}:
buildHelixPlugin (finalAttrs: {
  pname = "forest.hx";
  version = "0-unstable-2026-08-22";
  cogName = "forest";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "7a67b05c6919c9a670a5591fe1e21832d1edcdda";
    hash = "sha256-0m8Az1B4mLzg9XFkYe3HQtpSiDkGz3c5N+8lFqZ95Ts=";
  };

  pluginDependencies = [
    glyph
    notify
  ];

  meta = {
    description = "A file explorer tree for Helix";
    homepage = "https://github.com/Ra77a3l3-jar/forest.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
