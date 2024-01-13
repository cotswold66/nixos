{ config, lib, pkgs, ... }:

{
  imports =
      ./hardware-configuration.nix
    [ 
      ../common/configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.hostName = "saturn"; # Define your hostname.
  networking.hostId = "deadbeef";
  networking.firewall.allowedTCPPorts = [ 22 32400 ];

  virtualisation = {
    # containers.storage.settings = {
    #   storage = {
    #     driver = "zfs";
    #     graphroot = "/var/lib/containers/storage";
    #     runroot = "/run/containers/storage";
    #   };
    # };
  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       swtpm.enable = true;
  #       ovmf.enable = true;
  #     };
  #   };
    podman = {
      enable = true;
    };
    oci-containers = {
      backend = "podman";
      containers = {
        "plex" = {
          extraOptions = [ "--network=host" ];
          hostname = "plex";
          image = "plexinc/pms-docker:latest";
          autoStart = true;
          environment = {
            TZ = "America/Chicago";
            ADVERTISE_IP = "http://192.168.1.2:32400";
          };
          volumes = [
            "plex-config:/config"
            "media:/data"
            "plex-transcode:/transcode"
          ];
        };
        "unifi" = {
          extraOptions = [ "--network=macnet" "--ip=192.168.1.15" ];
          hostname = "unifi";
          image = "lscr.io/linuxserver/unifi-controller:latest";
          autoStart = true;
          environment = {
            TZ = "America/Chicago";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "unifi:/config"
          ];
        };
        "pihole" = {
          extraOptions = [ "--network=macnet" "--ip=192.168.1.6" ];
          hostname = "pihole";
          image = "pihole/pihole:latest";
          autoStart = true;
          environment = {
            TZ = "America/Chicago";
          };
          volumes = [
            "pihole-etc:/etc/pihole"
            "dnsmasq-etc:/etc/dnsmasq.d"
          ];
        };
        "rest-server" = {
          ports = [ "8000:8000" ];
          hostname = "rest-server";
          image = "restic/rest-server:latest";
          autoStart = true;
          environment = {
            DISABLE_AUTHENTICATION = "1";
          };
          volumes = [
            "/backup/restic:/data"
          ];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  services.openssh = {
    enable = true;
  };
 
  services.fstrim.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?

}

