{ config, lib, pkgs, ... }:

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
    devices = {
      "saturn" = { id = "5LE5FS7-ZAOZQ4A-S7DGNFJ-A4EJ2A6-23ZKYZJ-MT7TEUV-2HBTMP6-6BOPPAB"; };
      "mini" = { id = "NCQQLWT-NW6VYG2-CHMBI4T-3U4X4OM-PETBZYS-LS5A5EW-DFRKEMB-4P74CAK"; };
    };
    folders = {
      "Default Folder" = {        # Name of folder in Syncthing, also the folder ID
        path = "/home/john/Sync";    # Which folder to add to Syncthing
        devices = [ "saturn" "mini" ];      # Which devices to share the folder with
      };
    };
  };

}
