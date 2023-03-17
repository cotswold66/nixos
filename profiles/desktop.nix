{ config, pkgs, lib, ... }:

{
  home-manager.users.john = { config, pkgs, ... }: {
    
    fonts.fontconfig.enable = true;
    
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Screenshots";
      };
    };
    
    home = {
      sessionVariables = {
        EDITOR = "${pkgs.emacs}/bin/emacsclient -c";
      };
      packages = with pkgs; [
        digikam
        dolphin
        # emacs
        fd                        # Search engine for emacs
        firefox-wayland
        fzf
        ghostscript               # Needed for emacs doc-view
        gnome.dconf-editor
        gnucash
        gramps
        hack-font
        inconsolata
        isync
        libsForQt5.breeze-qt5
        libsForQt5.breeze-icons
        libsForQt5.kmahjongg
        libsForQt5.kshisen
        libreoffice-fresh
        mosh
        mu
        networkmanagerapplet
        networkmanager-openvpn
        noto-fonts
        osm-gps-map
        pass
        pcloud
        picmi
        pinentry-curses
        qt5ct
        restic
        ripgrep                   # Needed for emacs search
        roboto
        source-code-pro
        xorg.xlsclients
      ];
    };
    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.magit
      ];
    };
    services.emacs = {
      enable = true;
    };
    programs.gpg = {
      enable = true;
    };
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 86400;
      maxCacheTtl = 86400;
      pinentryFlavor = "curses";
    };
  };
}
