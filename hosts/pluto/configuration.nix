{ config, pkgs, inputs, lib, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
    ./restic.nix
  ];

  users.users.john.extraGroups = [ "networkmanager" "wheel" "libvirtd" ];

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
      # availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      # kernelModules = [ ];
      luks.devices."luks-62c5b522-ffbc-4a23-a5aa-d29eb22d7404" = {
        allowDiscards = true;
      };
    };
    # kernelModules = [ "kvm-intel" ];
    # extraModulePackages = [ ];
  };
  
  networking = {
    hostName = "pluto";
    networkmanager.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  console.useXkbConfig = true;

  services.xserver.xkb.layout = "dk";

  # Enable printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
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

  environment.gnome.excludePackages = (with pkgs; [
    gedit
    gnome-photos
    gnome-tour
    power-profiles-daemon
  ]) ++ (with pkgs.gnome; [
    gnome-calendar
    gnome-contacts
    gnome-music
    epiphany # web browser
    geary # email reader
  ]);
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
    };
  };

  programs.dconf.enable = true;
  
  services.fwupd.enable = true;
  
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "john" ];
  };

  programs._1password.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  system.stateVersion = "23.11"; # Did you read the comment?

  services.fstrim.enable = true;

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

