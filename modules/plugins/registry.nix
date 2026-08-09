# Per plugin descriptors, one file per plugin.
{ lib }:
[
  (import ./forest.nix { inherit lib; })
  (import ./moka.nix { inherit lib; })
  (import ./oil.nix { inherit lib; })
  (import ./scopeline.nix { inherit lib; })
]
