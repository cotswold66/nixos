{ config, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # imports =
  #   [ 
  #     ./dconf
  #     ./editors
  #     ./email
  #     ./browsers
  #   ];

  home = {
    username = "john";
    homeDirectory = "/home/john";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    packages = with pkgs; [
      # adwaita-qt
      # brave
      # dconf2nix
      # digikam
      emacs-nox
      # firefox-wayland
      # font-awesome
      # gimp
      # gnucash
      # gnome.dconf-editor
      # gnome.gnome-mahjongg
      # gnome.gnome-mines
      # gnome-extension-manager
      # gnumake
      # gramps
      # hack-font
      # kshisen
      # libreoffice
      # libertinus
      # microsoft-edge
      # mosh
      # networkmanagerapplet
      # networkmanager-openvpn
      # noto-fonts
      # pcloud
      # pdfarranger
      # picmi
      # qt5ct
      # restic
      # roboto
      rsync
      # telegram-desktop
      tmux
      # wl-clipboard
      # xorg.xlsclients
      # zoom-us
      # zotero
    ];
    stateVersion = "23.11"; # Please read the comment before changing.
    file = {
      ".local/bin/" = {
        source = ./files/restic;
        recursive = true;
      };
    };
  };


  # fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignoredups" ];
    initExtra = ''
      bind '"\e[A": history-search-backward'
      bind '"\eOA": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\eOB": history-search-forward'
            
      PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
      '';
    shellAliases = {
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ip = "ip -color=auto";
      ls = "ls --color=auto";
      ll = "ls -lh --color=auto";
      la = "ls -alh --color=auto";
    };
    sessionVariables = {
      LESS = "-R";
      SSH_AUTH_SOCK=/run/user/1000/keyring/ssh; # Needed for magit
    };
  };

  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "John Lord";
    userEmail = "john@lordsonline.org";
    extraConfig = {
      core.editor = "${pkgs.emacs-nox}/bin/emacsclient -c";
      init.defaultBranch = "main";
      pull.rebase = "false";
    };
  };

  programs.password-store = {
    enable = true;
    settings = { PASSWORD_STORE_DIR = "$HOME/src/password-store"; };
  };


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    # pinentryFlavor = "qt";
  };

  # xdg.configFile = {
  #   "chrome-flags.conf".source = ./files/chrome-flags.conf;
  #   # "chromium-flags.conf".source = ./files/chromium-flags.conf;
  #   "electron-flags.conf".source = ./files/electron-flags.conf;
  # };

  # xdg.userDirs = {
  #   enable = true;
  #   createDirectories = true;
  #   extraConfig = {
  #     XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Screenshots";
  #   };
  # };
  
  programs.home-manager.enable = true;

}
