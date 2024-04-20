{ agdaPackages }:
let
  inherit (agdaPackages) standard-library;
  pname = "standard-library-doc";
  everythingFile = "./README.agda";
in
agdaPackages.mkDerivation {
  inherit (standard-library) version meta;
  inherit pname everythingFile;
  name = pname;

  buildInputs = [ standard-library ];

  outputs = [
    "out"
    "html"
  ];

  src = "${standard-library.src}/doc";

  preConfigure = ''
    substituteInPlace "${pname}.agda-lib" \
      --replace-fail '../src' ""

    echo 'depend: standard-library' >> "${pname}.agda-lib"

    substituteInPlace "${everythingFile}" \
      --replace-fail 'import EverythingSafe' "" \
      --replace-fail 'import Everything' ""
  '';

  preBuild = ''
    echo "Creating html dir at '$html'..."
    mkdir -p "$html"
    agda --html --html-dir="$html" ${everythingFile}
  '';
}
