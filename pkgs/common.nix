{ lib }:
{
  installScmFiles = ''
    (
      shopt -s globstar
      
      for file in **/*.scm; do
        install -Dm 644 "$file" "$out/$file"
      done
    )
  '';

  setupSteelHomeForTests =
    { pluginDependencies, steel-test }:
    ''
      export STEEL_HOME=$(mktemp -d)
      mkdir -p $STEEL_HOME/cogs
      ln -s ${steel-test} $STEEL_HOME/cogs/steel-test

      # link plugin deps
      ${
        (lib.concatMapStrings (dep: ''
          ln -s ${dep} $STEEL_HOME/cogs/${dep.cogName}
        '') pluginDependencies)
      }
    '';

  runSteelTests = ''
    if [ -f tests/run-all.sh ]; then
      echo "Found tests/run-all.sh"
      sh tests/run-all.sh
    elif [ -d tests ]; then
      shopt -s nullglob; test_files=(tests/*.scm); shopt -u nullglob
      
      # fallback to running tests manually if there is no script
      if [ ''${#test_files[@]} -gt 0 ]; then
        echo "No tests/run-all.sh found"
        echo "But found individual test files"
        for f in "''${test_files[@]}"; do
          echo "Running $f..."
          steel "$f"
        done
      else
        echo "no tests found"
      fi
    else
      echo "no tests found"
    fi
  '';
}
