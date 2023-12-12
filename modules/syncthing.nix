{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    syncthing
    syncthing-tray
  ];
  services.syncthing = {
    enable = true;
    user = "john";
    dataDir = "/home/john/Sync";
    configDir ="/home/john/.config/syncthing";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "saturn" = { id = "LHZVRRZ-S2DRTAZ-PW4WUNI-ZZS7NIT-CRXLYCR-QCK6B2Q-WBJIWAP-FX43SQA"; };
        "mini" = { id = "NCQQLWT-NW6VYG2-CHMBI4T-3U4X4OM-PETBZYS-LS5A5EW-DFRKEMB-4P74CAK"; };
      };
      folders = {
        "Default Folder" = {        # Name of folder in Syncthing, also the folder ID
          path = "~/Sync";
          id = "Sync";
          devices = [ "saturn" "mini" ];      # Which devices to share the folder with
        };
      };
    };
  };
}
