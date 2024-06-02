{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ../common/home.nix
      ../../apps/chromium.nix
      # ../../apps/dconf.nix
      ../../apps/emacs.nix
      ../../apps/notmuch.nix
      ../../apps/sway.nix
      ../../apps/vim.nix
    ];

  home = {
    packages = with pkgs; [
      adwaita-qt
      # brave
      # dconf2nix
      digikam
      exiftool
      firefox
      font-awesome
      gimp
      gnucash
      # gnome.dconf-editor
      gnome.gnome-mahjongg
      gnome.gnome-mines
      gnome-extension-manager
      gnumake
      gramps
      hack-font
      kshisen
      libreoffice
      libertinus
      microsoft-edge
      # networkmanagerapplet
      networkmanager-openvpn
      noto-fonts
      # pcloud
      pdfarranger
      picmi
      qt5ct
      roboto
      scummvm
      telegram-desktop
      virt-manager
      wl-clipboard
      xorg.xlsclients
      xournalpp
      zoom-us
      zotero
    ];
    # pointerCursor = {
    #   x11.enable = true;
    #   gtk.enable = true;
    #   package = pkgs.vanilla-dmz;
    #   name = "Vanilla-DMZ";
    #   size = 32;
    # };
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  fonts.fontconfig.enable = true;

  programs.bash = {
    initExtra = ''
      # Base16 Shell
      # BASE16_SHELL="$HOME/src/base16-shell/"
      BASE16_SHELL="${inputs.base16-shell}"
      [ -n "$PS1" ] && \
          [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
              source "$BASE16_SHELL/profile_helper.sh"
      base16_tomorrow-night
      
      # Eat shell integration
      [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
        source "$EAT_SHELL_INTEGRATION_DIR/bash"
      '';
    sessionVariables = {
      LESS = "-R";
      QT_QPA_PLATFORM = "wayland";
      # QT_QPA_PLATFORMTHEME = "qt5ct";
      SSH_AUTH_SOCK=/run/user/1000/keyring/ssh; # Needed for magit
      VDPAU_DRIVER = "va_gl";
      VISUAL = "emacsclient -c";
      EDITOR = "emacsclient -c";
    };
  };

  xdg.configFile = {
    "chrome-flags.conf".source = ../../files/chrome-flags.conf;
    "electron-flags.conf".source = ../../files/electron-flags.conf;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Screenshots";
    };
  };
}
