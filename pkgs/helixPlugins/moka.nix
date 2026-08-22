{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "moka.hx";
  version = "0-unstable-2026-08-22";
  cogName = "moka";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "6c0865244d338e800fe49427d9e70fb2b750b2a0";
    hash = "sha256-w8IV+mZCkz98FvSc3m3lbQTm7eHk+HPlFaxQmQKsdnU=";
  };

  meta = {
    description = "A fully configurable statusline and bufferline for Helix.";
    homepage = "https://github.com/Ra77a3l3-jar/moka.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
