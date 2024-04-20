{
  description = "Agda docsets for Dash/Zeal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agda-index.url = "github:phijor/agda-index";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        cubical-doc = pkgs.callPackage ./cubical { };
        standard-library-doc = pkgs.callPackage ./standard-library { };

        agda-index = inputs.agda-index.packages.${system}.agda-index;

        mkDocs =
          drv:
          let
            inherit (drv) name;
          in
          pkgs.runCommand "${name}-docset" { } ''
            ${agda-index}/bin/agda-index ${drv.html} \
              --output-format docset \
              --library-name ${name}
            mkdir -p "$out"
            cp -r ${name}.docset "$out/"
          '';

        docsets = {
          cubical-docset = mkDocs cubical-doc;
          standard-library-docset = mkDocs standard-library-doc;
        };
      in
      {
        packages = {
          default = pkgs.linkFarm "agda-docsets" docsets;
        } // docsets;
      }
    );
}
