{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "wakatime.hx";
  version = "0-unstable-2026-05-05";
  cogName = "wakatime";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "Xerxes-2";
    repo = finalAttrs.pname;
    rev = "47a65d9df4d19892c9384b9bdfd850d78549ad23";
    hash = "sha256-KbcYdIAxN+7ORp83CoYMQqHTfszQwdrTASxHRNqGz1g=";
  };

  meta = {
    description = "Wakatime plugin for Helix Steel";
    homepage = "https://github.com/Xerxes-2/wakatime.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
