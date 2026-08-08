{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "http2curl.scm";
  version = "0.3.0";
  cogName = "http2curl";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-wsiJLJAdxX08vEGUdJ+qe3pwhC0x2XbmzJbIC38ywVQ=";
  };

  doSteelCheck = true;

  meta = {
    description = "A Steel Scheme cog to translate a .http request to curl";
    homepage = "https://github.com/waddie/http2curl.scm";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
