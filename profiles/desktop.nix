{ config, pkgs, lib, ... }:

{
  home-manager.users.john = { pkgs, ... }: {
    home = {
      sessionVariables = {
        EDITOR = "${pkgs.emacs}/bin/emacsclient -c";
      };
      packages = with pkgs; [
        digikam
        dolphin
        emacs
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
  };
  
}
