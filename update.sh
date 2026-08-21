#!/usr/bin/env -S nix shell nixpkgs#jq nixpkgs#nix-update --command bash

# shellcheck shell=bash
# -*- mode: bash -*-

# run `./update.sh` from the repos root to update all packages
# according to their updateVersion (passthru.updateVersion)
# this gets passed to nix-update --version=$updateVersion

set -uo pipefail

system=$(nix eval --raw --impure --expr 'builtins.currentSystem')

echo "Checking plugin updateVersions..."
versions_json=$(nix eval --json ".#legacyPackages.${system}.helixPlugins" --apply '
  plugins:
  builtins.mapAttrs (n: v:
    if (builtins.tryEval v).success && (v.type or "") == "derivation"
    then v.passthru.updateVersion or "stable"
    else null
  ) plugins
' | jq 'with_entries(select(.value != null))')

if [ $# -gt 0 ]; then
  targets=("$@")
else
  readarray -t targets < <(echo "$versions_json" | jq -r 'keys[]')
fi

for plugin in "${targets[@]}"; do
  version=$(echo "$versions_json" | jq -r ".\"$plugin\" // empty")

  if [ -z "$version" ]; then
    echo "⚠️  Package '$plugin' not found"
    continue
  fi

  if [[ "$version" == "skip" ]]; then
    echo "⏭️  Skipping $plugin (marked as 'skip')"
    echo
    continue
  fi

  echo "Updating $plugin with version=$version"

  args=("--flake"
        "legacyPackages.${system}.helixPlugins.${plugin}"
        "--version=$version"
        )

  if nix-update "${args[@]}"; then
    echo "✅: $plugin updated"
  else
    echo "⚠️  Failed to update $plugin, continuing..."
  fi
  echo
done
