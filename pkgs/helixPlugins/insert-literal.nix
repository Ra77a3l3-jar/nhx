{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "insert-literal.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-RxZ8nT3ZSHTtKcbR3JMKg3V7SL2nzccLjiqUnmiOcnw=";
  };

  meta = {
    description = "Insert the next keypress literally, or just suppress auto-pairing";
    homepage = "https://github.com/waddie/insert-literal.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
