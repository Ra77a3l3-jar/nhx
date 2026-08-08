{ lib }:
let
  inherit (lib) concatStringsSep optionalString;
in
rec {
  str = s: "\"${s}\"";
  sym = s: "'${s}";
  kw = k: "#:${k}";
  bool = b: if b then "#t" else "#f";
  call = name: args: "(${name}${optionalString (args != [ ]) (" " + concatStringsSep " " args)})";
  list = items: "(list${optionalString (items != [ ]) (" " + concatStringsSep " " items)})";
  quoteList = items: "'(${concatStringsSep " " items})";
  hash = entries: "(hash${optionalString (entries != [ ]) (" " + concatStringsSep " " entries)})";
  hashEntry = k: v: "${k} ${v}";
  indent = prefix: lines: concatStringsSep "\n" (map (l: prefix + l) lines);
  empty = "'()";
}
