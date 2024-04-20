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
        agda-index = inputs.agda-index.packages.${system}.agda-index;
        lib = pkgs.callPackage ./lib { inherit agda-index; };

        cubical-doc = pkgs.callPackage ./cubical { };
        standard-library-doc = pkgs.callPackage ./standard-library { };

        docsets = {
          cubical-docset = lib.mkDocset cubical-doc { name = "cubical"; };
          standard-library-docset = lib.mkDocset standard-library-doc { name = "standard-library"; };
        };
      in
      {
        packages = {
          inherit agda-index;
          default = pkgs.linkFarm "agda-docsets" docsets;
        } // docsets;
      }
    );
}
