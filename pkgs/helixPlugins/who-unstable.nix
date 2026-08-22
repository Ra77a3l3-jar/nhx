{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,

  notify,
}:

buildHelixPlugin (finalAttrs: {
  pname = "who.hx";
  version = "0-unstable-2026-07-19";
  cogName = "who";
  updateVersion = "skip"; # tracks the unstable branch, not the default

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    rev = "2dac2309f9047c0408bf71c441883ac8e72370e8";
    hash = "sha256-z5MH1Mq/AgP82cY8TKlLS/r4azymSgbGVrwXZQ5oekU=";
  };

  pluginDependencies = [
    notify
  ];

  meta = {
    description = "who.hx shows inline git blame for Helix (unstable branch).";
    homepage = "https://github.com/Ra77a3l3-jar/who.hx";
    license = lib.licenses.mit;
  };
})
