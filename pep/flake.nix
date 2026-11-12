{
  description = "Dissertação/tese INF-UFRGS escrita em Org-mode, exportada e compilada para PDF";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    infufrgs = {
      url = "github:schnorr/infufrgs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, infufrgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        paper = import ./default.nix { inherit pkgs infufrgs; };
      in
      {
        packages.default = paper.pdf;
        devShells.default = paper.shell;
      }
    );
}
