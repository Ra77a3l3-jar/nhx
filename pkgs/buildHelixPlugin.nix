{
  lib,
  stdenvNoCC,
  steel,
  steel-test,
}:

args:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    resolvedArgs = if builtins.isFunction args then args finalAttrs else args;

    # necessary args
    pname = resolvedArgs.pname; # typically the repo name
    version = resolvedArgs.version; # gets filled out by nix-update
    src = resolvedArgs.src;

    # optional args
    pluginDependencies = resolvedArgs.pluginDependencies or [ ]; # other plugins that should also be installed
    cogName = resolvedArgs.cogName or pname; # should be the cogs name (also used as the path in the modules)
    updateVersion = resolvedArgs.updateVersion or "stable"; # used for the update script; should be "stable" for tags, "unstable" for tags with "-alpha" suffix or similar, "branch" to follow the default branch, or "skip" if it should be skipped entirely
    doSteelCheck = resolvedArgs.doSteelCheck or resolvedArgs.doCheck or false;

    # internal mapping
    doCheck = doSteelCheck;

    # only put args here that arent supposed to be merged into the mkDerivation set
    extraArgs = removeAttrs resolvedArgs [
      "cogName"
      "pluginDependencies"
      "updateVersion"
      "doSteelCheck"
      "doCheck" # to not bypass the resolved arg
    ];

    common = import ./common.nix { inherit lib; };
  in
  {
    # this inherit is only for readability as these are overwritten by the merge
    # with extraArgs to preserve the source position of src for nix-update to work
    inherit
      pname
      version
      src
      doCheck
      ;

    name = "helix-plugin-${pname}-${version}";

    strictDeps = true;
    __structuredAttrs = true;

    dontBuild = true;
    dontConfigure = true;

    nativeCheckInputs = lib.optionals doCheck [ steel ];

    checkPhase = lib.optionalString doCheck ''
      ${common.setupSteelHomeForTests { inherit pluginDependencies steel-test; }}

      runHook preCheck

      ${common.runSteelTests}

      runHook postCheck
    '';

    installPhase = ''
      mkdir -p $out

      runHook preInstall

      ${common.installScmFiles}

      runHook postInstall
    '';

    passthru = {
      inherit cogName pluginDependencies updateVersion;
      native = null;
    };
  }
  // extraArgs # this also inherits pname version src
)
