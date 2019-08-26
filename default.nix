{ pkgs ? import <nixpkgs> {},
  coq ? import (fetchTarball "https://github.com/coq/coq/tarball/master") {} }:

pkgs.stdenv.mkDerivation rec {
  name = "bignums";
  src = ./.;
  buildInputs = with coq.ocamlPackages; [ coq ocaml findlib dune ];
  installFlags = "COQLIB=$(out)/lib/coq/";
}
