{ config, pkgs, inputs, lib, modulesPath, ... }:

{
  nixpkgs.overlays = [
    ( final: prev:
      {
        libnvme = prev.libnvme.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            (prev.fetchpatch {
              url = "https://github.com/linux-nvme/libnvme/pull/727.patch";
              hash = "sha256:0SrR1++QTXNq+X4YOpW3JzEjFdSSBdqPl/xI2zdcvTs=";
            })
          ];
        });
      } )
    ( final: prev:
      {
        libblockdev = prev.libblockdev.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            (prev.fetchpatch {
              url = "https://github.com/storaged-project/libblockdev/pull/969.patch";
              hash = "sha256:LHeotKzcRDdT/GhH3JdVjX/7ZMN1ghllYuaxPYsCZMY=";
            })
          ];
        });
      } )
  ];



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
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."luks-62c5b522-ffbc-4a23-a5aa-d29eb22d7404" = {
        device = "/dev/disk/by-uuid/62c5b522-ffbc-4a23-a5aa-d29eb22d7404";
        allowDiscards = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
  
  networking = {
    hostName = "pluto";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
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
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    power-profiles-daemon
  ]) ++ (with pkgs.gnome; [
    gnome-calendar
    gnome-contacts
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
  ]);

  console.useXkbConfig = true;

  services.xserver.layout = "dk";

  # Enable printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.tlp.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;

  security.polkit.enable = true;  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    virt-manager
    wget
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
    };
  };

  programs.dconf.enable = true;
  
  services.fwupd.enable = true;
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "john" ];
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  
  system.stateVersion = "23.11"; # Did you read the comment?
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/78583592-c5f9-4346-accc-a1520b027192";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0732-2B8B";
      fsType = "vfat";
    };

  swapDevices = [ ];

  services.fstrim.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

}

