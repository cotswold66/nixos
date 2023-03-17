{ config, pkgs, inputs, lib, modulesPath, ... }:

{
  # Use the grub EFI boot loader due to HiDPI screen
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1024x768";
        gfxpayloadEfi = "keep";
        fontSize = 30;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices."root".device = "/dev/disk/by-uuid/c7f90ee9-be7a-4c12-89f1-d0c3f093c0b0";
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
  
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "john" ];
  };
  
  services.fwupd.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  system.stateVersion = "22.11"; # Did you read the comment?
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6e9a0dc3-f1a1-4e33-9cf9-06329b7c6941";
      fsType = "btrfs";
      options = [ "subvol=@nixos" ];
    };

#  fileSystems."/home" =
#    { device = "/dev/disk/by-uuid/6e9a0dc3-f1a1-4e33-9cf9-06329b7c6941";
#      fsType = "btrfs";
#      options = [ "subvol=@home-nixos" ];
#    };
#
#  fileSystems."/var/lib/libvirt" =
#    { device = "/dev/disk/by-uuid/6e9a0dc3-f1a1-4e33-9cf9-06329b7c6941";
#      fsType = "btrfs";
#      options = [ "subvol=@libvirt" ];
#    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BD99-62EC";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.video.hidpi.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

}

