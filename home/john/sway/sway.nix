{ config, pkgs, lib, ... }:

{
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
      grim
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
  # xdg.configFile = {
  #   "electron-flags.conf".text = ''
  #         --enable-features=WaylandWindowDecorations
  #         --ozone-platform-hint=auto
  #       '';
  #   "tmux/tmux.conf".source = ../files/tmux.conf;
  #   "sway" = {
  #     source = ../files/sway;
  #     recursive = true;
  #   };
  # };
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
      exec ${pkgs.sway}/bin/sway
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

  wayland.windowManager.sway = 
    let
      mod = "Mod4";
      screenshot = "1 save active, 2 save area, 3 save screen, 4 save window";
    in
      {
        enable = true;
        wrapperFeatures.gtk = true;
        # extraConfig = builtins.readFile ./sway/config;
        extraConfig = ''
          bindswitch --reload --locked lid:on output $laptop disable
          bindswitch --reload --locked lid:off output $laptop enable
        '';
        extraSessionCommands = ''
          export QT_QPA_PLATFORM=wayland
        '';
        config = rec {
          modes = lib.mkOptionDefault {
            "${screenshot}" = {
              "1" = ''exec 'grimshot --notify save active', mode "default"'';
              "2" = ''exec 'grimshot --notify save area', mode "default"'';
              "3" = ''exec 'grimshot --notify save output', mode "default"'';
              "4" = ''exec 'grimshot --notify save window', mode "default"'';
              Return = ''mode "default"'';
              "${mod}+Print" = '' mode "default"'';
              Escape = "mode default";
            };
          };
          assigns = {
            "3" = [ { app_id = "virt-manager"; } { class = "zoom"; } ];
            "6" = [{ app_id = "gnucash"; }];
          };
          floating.modifier = mod;
          modifier = mod;
          terminal = "foot";
          fonts = {
            names = [ "Roboto" ];
            size = 10.0;
          };
          window.border = 5;
          window.commands = [
            { command = "floating enable"; criteria = { app_id = "dolphin"; }; }
            { command = "floating enable"; criteria = { app_id = "virt-manager"; }; }
            { command = "floating enable"; criteria = { class = "zoom"; }; }
            { command = "floating enable"; criteria = { app_id = "1Password"; }; }
          ];
          menu = "wofi --show drun --lines=5 --prompt='' | xargs swaymsg exec --";
          bars = [
            { command = "waybar"; }
          ];
          gaps.smartBorders = "on";
          input = {
            "1452:544:Apple,_Inc_Apple_Keyboard" = {
              xkb_layout = "us";
              xkb_options = "altwin:swap_alt_win";
            };
            "1:1:AT_Translated_Set_2_keyboard" = {
              xkb_layout = "dk";
            };
            "type:touchpad" = {
              tap = "enabled";
              natural_scroll = "enabled";
            };
          };
          output = 
            let
              laptop = "eDP-1";
              external = "''Goldstar Company Ltd LG HDR 4K 0x00006FD4''";
            in {
              "${laptop}" = {
                # Set HIDP scale (pixel integer scaling)
                scale = "2";
                pos = "0 0";
                res = "3840x2400";
              };
              "${external}" = {
                scale = "1";
                pos = "1920 0";
                res = "3840x2160";
              };
              "*".bg = "${./storm.png} fill";

            };
          keybindings =
            lib.mkOptionDefault {
              "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Suspend' 'systemctl suspend' -b 'Lock' '$lockman' -b 'Shutdown' 'systemctl poweroff' -b 'Reboot' 'systemctl reboot' -b 'Yes, exit sway' 'swaymsg exit'";
              "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "Ctrl+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
              "Ctrl+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
              "Ctrl+XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              "Ctrl+${mod}+l" = "exec ${pkgs.swaylock}/bin/swaylock -c 550000";
              "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
              "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
              "XF86AudioPlay" = "exec playerctl play-pause";
              "Ctrl+Shift+l" = "exec 1password --toggle";
              "Ctrl+Shift+space" = "exec 1password --quick-access";
              "${mod}+Print" = ''mode "${screenshot}"'';
            };
          startup = [
            { command = "${./homescreen.sh}"; }
            { command = "nm-applet --indicator"; }
            { command = "${pkgs._1password-gui}/bin/1password --silent"; }
            { command = "pcloud"; }
            { command = "mako"; }
            { command = "wl-paste -t text --watch clipman store --no-persist"; }
          ];

        };
      };
}
