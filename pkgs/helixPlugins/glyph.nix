{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin (finalAttrs: {
  pname = "glyph.hx";
  version = "0.2.0";
  cogName = "glyph";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-TpYnGqROkKfoB9G+JTjADWvMtpRJbv4NVaTqiUfW1Eg=";
  };

  meta = {
    description = "shared icon library for Helix plugins";
    homepage = "https://github.com/Ra77a3l3-jar/glyph.hx";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
