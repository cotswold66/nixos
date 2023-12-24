{ config, pkgs, inputs, lib, ... }:

{

  imports = [
    # ./hardware-configuration.nix
  ];

  users.users.john = {
    isNormalUser = true;
    description = "John Lord";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "podman" ];
    password = "john";
    uid = 1000;
    packages = with pkgs; [
    ];
  };


  # Use the grub EFI boot loader due to HiDPI screen
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1600x1200";
        gfxpayloadEfi = "keep";
        fontSize = 30;
      };
      efi.canTouchEfiVariables = true;
    };
    # kernelModules = [ "kvm-intel" ];
    # extraModulePackages = [ ];
  };
  
  networking = {
    hostName = "saturn";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Chicago";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  

  services.tlp.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;

  security.polkit.enable = true;  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
      };
    };
    docker.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
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
            ADVERTISE_IP = "http://localhost:32400";
          };
          volumes = [
            "plex-config:/config"
            "plex-data:/data"
            "plex-transcode:/transcode"
          ];
        };
      };
    };
  };

 virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
      forwardPorts = [
        { from = "host"; host.port = 32400; guest.port = 32400; }
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  system.stateVersion = "23.11"; # Did you read the comment?

  services.fstrim.enable = true;

}

