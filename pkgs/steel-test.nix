{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  steel,
}:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    common = import ./common.nix { inherit lib; };
  in
  {
    pname = "steel-test";
    version = "0.5.0";

    src = fetchFromGitHub {
      owner = "waddie";
      repo = finalAttrs.pname;
      tag = "v${finalAttrs.version}";
      hash = "sha256-I20cwSKOcn0mLvGUy5uQRCuf3wSp6CRxsI5Co9D6VrY=";
    };

    strictDeps = true;
    __structuredAttrs = true;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out

      runHook preInstall

      ${common.installScmFiles}

      runHook postInstall
    '';

    doCheck = true;
    nativeCheckInputs = [ steel ];

    checkPhase = ''
      ${common.setupSteelHomeForTests {
        steel-test = "$PWD";
        pluginDependencies = [ ];
      }}

      runHook preCheck

      ${common.runSteelTests}

      runHook postCheck
    '';

    meta = {
      description = "Unit testing for Steel Scheme, modelled on clojure.test";
      homepage = "https://github.com/waddie/steel-test";
      license = lib.licenses.mit;
      # maintainers = with lib.maintainers; [ ];
    };
  }
)
