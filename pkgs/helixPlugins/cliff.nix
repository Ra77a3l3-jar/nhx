{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:

buildHelixPlugin (finalAttrs: {
  pname = "cliff.hx";
  version = "0-unstable-2026-07-29";
  cogName = "cliff";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "a188886aa5625e4da01b9714033a035bd5f6fed8";
    hash = "sha256-oecsWoSoTIQvJohMKhylxEdanfqHgsihQTiLjNYXwvo=";
  };

  meta = {
    description = "Tree-sitter code folding for Helix (Steel plugin).";
    homepage = "https://github.com/Ra77a3l3-jar/cliff.hx";
    license = lib.licenses.mit;
  };
})
