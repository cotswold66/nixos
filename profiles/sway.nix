{ config, pkgs, lib, ... }:

{
  
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

  home-manager.users.john = { pkgs, ... }: {
    imports = [
      ../mixins/foot.nix
      ../mixins/chromium.nix
    ];
    home = {
      file = {
        ".config/electron-flags.conf".source = ../files/electron-flags.conf;
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
        xorg.xlsclients
      ];
    };
  };
}
