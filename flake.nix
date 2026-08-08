{
  description = "nhx declarative Helix configuration with Steel plugin support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = nixpkgs.lib.systems.flakeExposed;
      eachSystem = f: nixpkgs.lib.genAttrs systems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      legacyPackages = eachSystem (system: pkgs: {
        helixPlugins = pkgs.callPackage ./pkgs { };
      });

      homeManagerModules = {
        nhx = import ./modules;
        default = self.homeManagerModules.nhx;
      };

      formatter = eachSystem (system: pkgs: pkgs.nixfmt);
    };
}
