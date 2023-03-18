{ config, pkgs, lib, ... }:

{
  imports = [
    ./desktop.nix
    ./common.nix
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
      ../mixins/sway.nix
      ../mixins/foot.nix
      ../mixins/waybar.nix
    ];
    home = {
      sessionVariables = {
        
      };
      file = {
        ".config/electron-flags.conf".text = ''
          --enable-features=WaylandWindowDecorations
          --ozone-platform-hint=auto
        '';
        ".config/sway/homescreen.sh".source = ../files/sway/homescreen.sh;
        ".mbsyncrc".source = ../files/mbsyncrc;
        ".config/tmux/tmux.conf".source = ../files/tmux.conf;
      };
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
        size = 22;
      };
      packages = with pkgs; [
        bibata-cursors
        brightnessctl
        clipman
        font-awesome              # Fonts used in waybar
        mako
        pinentry-curses
        restic
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
