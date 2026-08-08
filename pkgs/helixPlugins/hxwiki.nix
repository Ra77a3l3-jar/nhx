{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "hxwiki";
  version = "0-unstable-2026-07-15";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "sipmann";
    repo = finalAttrs.pname;
    rev = "754143626b494cea885d3ce5337ec994e6ec7062";
    hash = "sha256-v/idL4XGJa0dI8zbjIb1kD1sucuTM1p82cVmpPayoG0=";
  };

  meta = {
    description = "A VimWiki-inspired wiki plugin for the Helix editor, built with Steel scripting — follow/create [[links]] and keep a daily diary without leaving the editor.";
    homepage = "https://github.com/sipmann/hxwiki";
    license = lib.licenses.agpl3Plus;
    # maintainers = with lib.maintainers; [ ];
  };
})
