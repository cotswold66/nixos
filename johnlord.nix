{ config, pkgs, inputs, ... }:
let
  # keys = inputs.self.nixosModules.ssot-keys;
in
{
 
  # nix.settings.trusted-users = [ "john" ];
  users.users.john = {
    isNormalUser = true;
    description = "John Lord";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
    ];
    # openssh.authorizedKeys.keys = keys.john;
  };

  home-manager.users.john = { config, pkgs, lib, ... }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    imports =
      [ 
        ./alacritty.nix
        ./dconf.nix
        # ./r.nix
        # ./tex.nix
      ];

    home = {
      username = "john";
      homeDirectory = "/home/john";
      sessionPath = [
        "$HOME/.local/bin"
      ];
      packages = with pkgs; [
        # bibata-cursors
        adwaita-qt
        brave
        brightnessctl
        clipman
        dconf2nix
        digikam
        fd
        firefox-wayland
        font-awesome
        ghostscript
        gimp
        gnucash
        gnome.dconf-editor
        gnome.gnome-mahjongg
        gnome.gnome-mines
        gnome-extension-manager
        gnumake
        gramps
        hack-font
        # inconsolata
        isync
        kshisen
        libreoffice
        libertinus
        mako
        microsoft-edge
        mosh
        mu
        networkmanagerapplet
        noto-fonts
        pcloud
        pdfarranger
        picmi
        # powerline-fonts
        qt5ct
        restic
        ripgrep
        roboto
        rsync
        source-code-pro
        stow
        sway
        sway-contrib.grimshot
        swaybg
        swayidle
        swaylock
        telegram-desktop
        tmux
        waybar
        wl-clipboard
        wofi
        xorg.xlsclients
        zoom-us
        zotero
      ];
      stateVersion = "23.11"; # Please read the comment before changing.
      file = {
        ".local/bin/" = {
          source = ./files/restic;
          recursive = true;
        };

      };
    };

    fonts.fontconfig.enable = true;

    programs.bash = {
      enable = true;
      historyControl = [ "erasedups" "ignoredups" ];
      initExtra = ''
bind '"\e[A": history-search-backward'
bind '"\eOA": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOB": history-search-forward'
      
# Base16 Shell
BASE16_SHELL="$HOME/src/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
base16_tomorrow-night

PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# Eat shell integration
[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/bash"
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
        XDG_SCREENSHOTS_DIR = "$HOME/Screenshots";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        VDPAU_DRIVER = "va_gl";
      };
    };

    programs.fzf.enable = true;

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "John Lord";
      userEmail = "john@lordsonline.org";
      extraConfig = {
        core.editor = "${pkgs.emacs29-pgtk}/bin/emacsclient -c";
        init.defaultBranch = "main";
        pull.rebase = "false";
      };
    };

    programs.password-store = {
      enable = true;
      settings = { PASSWORD_STORE_DIR = "$HOME/src/password-store"; };
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor= true;
      package = pkgs.emacs29-pgtk;
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 86400;
      maxCacheTtl = 86400;
      # pinentryFlavor = "qt";
    };

    xdg.configFile = {
      "picmirc".source = config.lib.file.mkOutOfStoreSymlink ./files/picmirc;
      "kshisenrc".source = config.lib.file.mkOutOfStoreSymlink ./files/kshisenrc;
      "chrome-flags.conf".source = ./files/chrome-flags.conf;
      "chromium-flags.conf".source = ./files/chromium-flags.conf;
      "electron-flags.conf".source = ./files/electron-flags.conf;
    };
  };
}