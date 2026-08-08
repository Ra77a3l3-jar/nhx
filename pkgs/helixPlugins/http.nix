{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  http2curl,
  run-command,
}:
buildHelixPlugin (finalAttrs: {
  pname = "http.hx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-WZ6UUvwmzlgVuHcirywORgWr/mV+0ocgNstwTT2Y0g0=";
  };

  pluginDependencies = [
    http2curl
    run-command
  ];

  meta = {
    description = "An http client for the Helix editor";
    homepage = "https://github.com/waddie/http.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
