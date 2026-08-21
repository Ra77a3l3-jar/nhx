{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "insert-literal.hx";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-z6VjJWnKiN4DCamzHLUwj2cEKu7ztBWfLdJyhCDYK68=";
  };

  meta = {
    description = "Insert the next keypress literally, or just suppress auto-pairing";
    homepage = "https://github.com/waddie/insert-literal.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
