{
  buildHelixPluginWithNative,
  fetchFromGitHub,
  lib,
  callPackage,
  libtexprintf ? callPackage ./libtexprintf.nix { }, # you need to provide this yourself
}:
buildHelixPluginWithNative (finalAttrs: {
  pname = "HeTex.hx";
  version = "0-unstable-2025-10-26";
  cogName = "hetex";
  updateVersion = "branch";

  src = fetchFromGitHub {
    owner = "daynardn";
    repo = finalAttrs.pname;
    rev = "ddf59364f9a82ecbeb7dca3d8ddb34e53ff98d9c";
    hash = "sha256-O0uE2h996v5Y9DChlMfFoLErrLVlvS99VhdXW0QQlcA=";
  };

  cargoHash = "sha256-DwR90JK7eZSnRcd07e2f/fPfaSpvJ+TtZKVcaNmTrzs=";

  buildInputs = [ libtexprintf ];

  postPatch = ''
    echo 'fn main() {
      println!("cargo:rustc-link-search=native=${libtexprintf}/lib");
      println!("cargo:rustc-link-lib=texprintf");
    }' > build.rs
  '';

  meta = {
    description = "An ascii rendered Helix LaTeX plugin";
    homepage = "https://github.com/daynardn/HeTeX.hx";
    license = lib.licenses.gpl3;
    # maintainers = with lib.maintainers; [ ];
  };
})
