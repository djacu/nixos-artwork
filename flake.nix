{
  description = "djacu's personal site";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-old.url = "github:NixOS/nixpkgs/c6b5632d7066510ec7a2cb0d24b1b24dac94cf82";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-old,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [];
        };
        pkgs-old = import nixpkgs-old {
          inherit system;
          overlays = [];
        };

        bosl2 = pkgs.stdenvNoCC.mkDerivation {
          pname = "bosl2";
          version = "2.0.652";
          src = pkgs.fetchFromGitHub {
            owner = "BelfrySCAD";
            repo = "BOSL2";
            rev = "c803f1a1710bbe87dd0a598699c59d50ead3b7ba";
            sha256 = "sha256-vGT71J5bMQ/C1puZ1MboUvw3v9YhL2GgIw77brr0hf8=";
          };
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/bosl2
            cp ./*.scad $out/bosl2/
          '';
        };

        constructive = pkgs.stdenvNoCC.mkDerivation {
          pname = "constructive";
          version = "0.1.0";
          src = pkgs.fetchFromGitHub {
            owner = "solidboredom";
            repo = "constructive";
            rev = "37e6ff024148d3447a81285eb1df1f7757c66959";
            sha256 = "sha256-0w2dlcgBR5qULAbs96PrJe5cxLVVhALU56vCaff9Rn8=";
          };
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/constructive
            cp ./*.scad $out/constructive/
            mkdir -p $out/constructive/sources
            cp ./sources/*.scad $out/constructive/sources/
          '';
        };

        libraries = pkgs.stdenvNoCC.mkDerivation {
          pname = "openscad-libraries";
          version = "0.1.0";
          dontUnpack = true;
          dontBuild = true;
          installPhase = ''
            mkdir -p $out
            cp -R ${bosl2}/* $out/
            cp -R ${constructive}/* $out/
          '';
        };

        wrapped-openscad =
          pkgs.runCommand "wrapped-openscad"
          {nativeBuildInputs = [pkgs.makeWrapper];}
          ''
            mkdir -p $out/bin
            ln -s ${pkgs-old.openscad}/bin/openscad $out/bin/openscad
            wrapProgram $out/bin/openscad \
              --set OPENSCADPATH ${libraries}
          '';
      in {
        packages = {
          inherit bosl2 constructive libraries;
          wopenscad = wrapped-openscad;
          openscad = pkgs-old.openscad;
        };
        #apps.openscad = wrapped-openscad;
      }
    );
}
