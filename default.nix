{ pkgs ? import <nixpkgs> {},
  coq ? import (fetchTarball "https://github.com/coq/coq/tarball/master") {} }:

coq.ocamlPackages.buildDunePackage {
  pname = "coq-bignums";
  version = "dev";

  src =
    with builtins; filterSource
      (path: _: !elem (baseNameOf path) [".git" "result" "_build"]) ./.;

  buildInputs = with coq.ocamlPackages; [ coq ocaml findlib dune ];
  installFlags = "COQLIB=$(out)/lib/coq/";
}
