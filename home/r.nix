{ config, pkgs, ... }:

with pkgs;
let
  r-custom = with rPackages; [
    bookdown
    emmeans
    janitor
    kableExtra
    quantmod
    tidyverse
  ];
  r-jdl = rWrapper.override{ packages = r-custom; };
  rstudio-jdl = rstudioWrapper.override{ packages = r-custom; };
in
{
  home = {
    packages = with pkgs; [
      r-jdl
      rstudio-jdl
    ];
  };
}
