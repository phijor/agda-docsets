{ agdaPackages }:

agdaPackages.mkDerivation {
  name = "cubical-wrapper";
  pname = "cubical-wrapper";
  src = ./.;
  everythingFile = "./index.agda";

  outputs = [
    "out"
    "html"
  ];

  buildInputs = [ agdaPackages.cubical ];

  meta = {
    description = "HTML documentation of cubical";
    platforms = agdaPackages.cubical.meta.platforms;
  };

  buildPhase = ''
    runHook preBuild
    echo "Creating html dir at '$html'..."
    mkdir -p "$html"
    agda --html --html-dir="$html" index.agda
    runHook postBuild
  '';
}
