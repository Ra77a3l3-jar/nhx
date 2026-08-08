{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "emotional.hx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "waddie";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-/oZ7kjQzuxV1OJVsap+L4VNZGRk2U06wyW2iqbuct9I=";
  };

  doSteelCheck = true;

  meta = {
    description = "Additional motions for Helix";
    homepage = "https://github.com/waddie/emotional.hx";
    license = lib.licenses.agpl3Only;
    # maintainers = with lib.maintainers; [ ];
  };
})
