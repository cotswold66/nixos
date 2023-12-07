{ config, lib, pkgs, ... }:

{
  services.nextcloud-client = {
    enable = true;
    package = pkgs.nextcloud-client;
  };
}
