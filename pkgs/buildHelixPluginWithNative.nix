{
  lib,
  rustPlatform,
  stdenv,
  steel,
  steel-test,
}:

args:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    resolvedArgs = if builtins.isFunction args then args finalAttrs else args;

    # necessary args
    pname = resolvedArgs.pname; # typically the repo name
    version = resolvedArgs.version; # gets filled out by nix-update
    src = resolvedArgs.src;
    cargoHash = resolvedArgs.cargoHash;

    # optional args
    pluginDependencies = resolvedArgs.pluginDependencies or [ ]; # other plugins that should also be installed
    cogName = resolvedArgs.cogName or pname; # should be the cogs name (also used as the path in the modules)
    updateVersion = resolvedArgs.updateVersion or "stable"; # used for the update script; should be "stable" for tags, "unstable" for tags with "-alpha" suffix or similar, "branch" to follow the default branch, or "skip" if it should be skipped entirely
    doSteelCheck = resolvedArgs.doSteelCheck or false;

    # only put args here that arent supposed to be merged into the mkDerivation set
    extraArgs = removeAttrs resolvedArgs [
      "cogName"
      "pluginDependencies"
      "updateVersion"
      "doSteelCheck"
    ];

    common = import ./common.nix { inherit lib; };

    installNativeLibsTo = targetDir: ''
      for file in target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/*${stdenv.hostPlatform.extensions.sharedLibrary}; do
        install -Dm 755 "$file" -t "${targetDir}/"
      done
    '';
  in
  {
    # this inherit is only for readability as these are overwritten by the merge
    # with extraArgs to preserve the source position of src for nix-update to work
    inherit
      pname
      version
      src
      cargoHash
      ;

    name = "helix-plugin-${pname}-${version}";

    strictDeps = true;
    __structuredAttrs = true;

    outputs = [
      "out"
      "native"
    ];

    cargoBuildFlags = [ "--lib" ];

    nativeCheckInputs = lib.optionals doSteelCheck [ steel ];

    postCheck = lib.optionalString doSteelCheck ''
      echo "Running Steel tests..." 

      ${common.setupSteelHomeForTests { inherit pluginDependencies steel-test; }}


      # native lib setup
      mkdir -p $PWD/native
      ${installNativeLibsTo "$PWD/native/"}

      ${common.runSteelTests}
    '';

    installPhase = ''
      mkdir -p $out $native

      runHook preInstall

      ${common.installScmFiles}

      ${installNativeLibsTo "$native/"}

      runHook postInstall
    '';

    passthru = { inherit cogName pluginDependencies updateVersion; };
  }
  // extraArgs
)
