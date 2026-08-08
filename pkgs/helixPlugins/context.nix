{
  buildHelixPlugin,
  fetchFromCodeberg,
  lib,

  breadcrumbs,
}:
buildHelixPlugin (finalAttrs: {
  pname = "context.hx";
  version = "0-unstable-2026-07-26";
  cogName = "context";
  updateVersion = "branch";

  src = fetchFromCodeberg {
    owner = "gwid";
    repo = finalAttrs.pname;
    rev = "62d185511d416cf7b3af38257480f6310870e6a1";
    hash = "sha256-ti+GOnm73Ug6Np5GT2ndaNoX1RESz9xV9MiHiIh6lZ4=";
  };

  pluginDependencies = [
    breadcrumbs
  ];

  postInstall = ''
    cp -r queries $out/queries
  '';

  meta = {
    description = "treesitter breadcrumbs with proper context queries";
    homepage = "https://codeberg.org/gwid/context.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
