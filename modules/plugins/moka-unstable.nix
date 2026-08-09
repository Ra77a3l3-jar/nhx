# Used for moka-unstable which shares the same config options
{ lib }:
let
  moka = import ./moka.nix { inherit lib; };
in
moka // {
  name = "moka-unstable";
  requirePath = "moka/moka.scm";
}
