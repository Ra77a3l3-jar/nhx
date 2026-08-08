{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "steel-pty";
  version = "0-unstable-2026-02-22";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = finalAttrs.pname;
    rev = "4d41b6988107b50777d87e587fba7b6b272f069e";
    hash = "sha256-7teIMyLmfPkNEhTFlzmtKaewwwDrlcgmx06prUqXz1g=";
  };
  cargoHash = "sha256-vUlSStpLgcOgpCgqWlcNFgDxemIoP0Hak3BG+iR6agc=";

  preBuild = ''
    echo "Locating the vendor directory in the build sandbox..."
    VENDOR_DIR=$(find /build -maxdepth 1 -type d -name "*-vendor" | head -n 1)

    if [ -n "$VENDOR_DIR" ] && [ -d "$VENDOR_DIR/source-git-0" ]; then
      echo "Making source-git-0 writable..."
      chmod u+w "$VENDOR_DIR/source-git-0"

      pushd "$VENDOR_DIR/source-git-0" > /dev/null

      # Find the exact versioned name of the termwiz directory
      TERMWIZ_DIR=$(find . -maxdepth 1 -type d -name "termwiz-*" | head -n 1)

      if [ -n "$TERMWIZ_DIR" ]; then
        echo "Creating symlink for $TERMWIZ_DIR..."
        ln -sf "$(basename "$TERMWIZ_DIR")" termwiz
      else
        echo "Error: termwiz directory not found!"
      fi

      popd > /dev/null
    fi
  '';

  meta = {
    description = "";
    homepage = "https://github.com/mattwparas/steel-pty";
    license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
  };
})
