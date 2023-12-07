{ config, pkgs, ... }:

with pkgs;
let
  tex-jdl = (texlive.combine {
    inherit (texlive) scheme-medium
      environ
      fontawesome
      multirow
      tabu
      threeparttable
      threeparttablex
      wrapfig;
    });
in
{
  home = {
    packages = with pkgs; [
      tex-jdl
    ];
  };
}
