{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libtexprintf";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "bartp5";
    repo = "libtexprintf";
    tag = "v${version}";
    hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
  };

  nativeBuildInputs = [ autoreconfHook ];
}
