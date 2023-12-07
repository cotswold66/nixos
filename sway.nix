{ config, pkgs, lib, ... }:

{
  imports = [
    # ./desktop.nix
    # ./common.nix
  ];
  
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  home-manager.users.john = { config, pkgs, ... }: {
    imports = [
      ./configs/sway.nix
      ./configs/foot.nix
      ./configs/waybar.nix
    ];
    home = {
      sessionVariables = {
        
      };
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };
      packages = with pkgs; [
        # bibata-cursors
        brightnessctl
        clipman
        font-awesome              # Fonts used in waybar
        mako
        # pinentry-curses
        roboto
        source-code-pro
        sway-contrib.grimshot
        swaybg
        swayidle
        swaylock
        wl-clipboard
        wofi
      ];
    };
    xdg.configFile = {
      "electron-flags.conf".text = ''
          --enable-features=WaylandWindowDecorations
          --ozone-platform-hint=auto
        '';
      "tmux/tmux.conf".source = ../files/tmux.conf;
      "sway" = {
        source = ../files/sway;
        recursive = true;
      };
    };
    gtk = {
      enable = true;
      font = {
        name = "Roboto";
        size = 11;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
    };
    programs.bash = {
      profileExtra = ''
      if [ -z "''${DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
      exec sway
      fi
    '';
    };

    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; }
      ];
      timeouts = [
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; }
        { timeout = 600; command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
          resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";}
      ];
    };
  };
}
