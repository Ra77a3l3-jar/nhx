{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  notify,
  glyph,
}:

buildHelixPlugin (finalAttrs: {
  pname = "oil.hx";
  version = "0-unstable-2026-07-29";
  cogName = "oil";
  updateVersion = "skip"; # tracks the unstable branch, not the default

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "5b7a27a95cbce4da4655f743b15db9b4c6d61efe";
    hash = "sha256-OPQVyF/EdrYRdMmWbvK39n1lajdlfCJYm/jdcoLySIk=";
  };

  pluginDependencies = [
    notify
    glyph
  ];

  meta = {
    description = "File Manager in a buffer for Helix editor (unstable branch).";
    homepage = "https://github.com/Ra77a3l3-jar/oil.hx";
    license = lib.licenses.mit;
  };
})
