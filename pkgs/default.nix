{ lib, newScope }:
lib.makeScope newScope (
  self:
  let
    helpers = {
      buildHelixPlugin = self.callPackage ./buildHelixPlugin.nix { };
      buildHelixPluginWithNative = self.callPackage ./buildHelixPluginWithNative.nix { };

      steel-test = self.callPackage ./steel-test.nix { };
    };

    plugins = lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage newScope;
      directory = ./helixPlugins;
    };
  in

  helpers // plugins
)
