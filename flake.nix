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
        cubical-wrapped = pkgs.callPackage ./cubical { };

        agda-index = inputs.agda-index.packages.${system}.agda-index;

        cubical-docs = pkgs.runCommand "cubical-docs" { } ''
          ${agda-index}/bin/agda-index ${cubical-wrapped.html} \
            --output-format docset \
            --library-name cubical
          mkdir -p "$out"
          cp -r cubical.docset "$out/"
        '';
      in
      {
        packages = {
          default = cubical-docs;
        };
      }
    );
}
