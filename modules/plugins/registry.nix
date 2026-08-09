# Per plugin descriptors, one file per plugin.
{ lib }:
[
  (import ./moka.nix { inherit lib; })
]
