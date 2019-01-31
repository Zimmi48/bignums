{ pkgs ? (import <nixpkgs> {})
, coqPackagesInfo ? {
    coq = "https://github.com/coq/coq/tarball/master";
  }
, shell ? false
}:

let coqPackages =
  if builtins.isString coqPackagesInfo then
    let coq-version-parts = builtins.match "([0-9]+).([0-9]+)" coqPackagesInfo; in
    pkgs."coqPackages_${builtins.concatStringsSep "_" coq-version-parts}"
  else {
    coq = import (fetchTarball coqPackagesInfo.coq) {};
  };
in

with coqPackages;

pkgs.stdenv.mkDerivation {

  name = "bignums";

  buildInputs = with coq.ocamlPackages; [ ocaml findlib ]
    ++ pkgs.lib.optionals shell [ merlin ocp-indent ocp-index ];

  propagatedBuildInputs = [
    coq
  ];

  src = if shell then null else ./.;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";
}
