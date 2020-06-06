{ nixpkgs ? import <nixpkgs> {} }:
nixpkgs.stdenv.mkDerivation {
    name = "blade-shadow-beta";
    buildInputs = with nixpkgs; [
        yarn
    ];
}