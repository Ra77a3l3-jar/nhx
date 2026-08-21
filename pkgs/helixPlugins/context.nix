{
  buildHelixPlugin,
  fetchFromCodeberg,
  lib,

  breadcrumbs,
}:
buildHelixPlugin (finalAttrs: {
  pname = "context.hx";
  version = "0-unstable-2026-08-15";
  cogName = "context";
  updateVersion = "branch";

  src = fetchFromCodeberg {
    owner = "gwid";
    repo = finalAttrs.pname;
    rev = "71a56d1565df7a24696edcd7cf2c4b37a520071a";
    hash = "sha256-uCulYYv1YUgy/oFcuuRL++Za8kgVlD6bQO7DYFzi4AA=";
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
