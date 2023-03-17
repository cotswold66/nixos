{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # extraConfig = builtins.readFile ./sway/config;
    extraConfig = ''
      # exec dex --autostart -s ~/.config/autostart/

      # output * bg $HOME/.local/share/backgrounds/p51XiSX-linux-background.jpg fill

      bindswitch --reload --locked lid:on output $laptop disable
      bindswitch --reload --locked lid:off output $laptop enable

      set $screenshot 1 save active, 2 save area, 3 save screen, 4 save window
      mode "$screenshot" {
        bindsym 1 exec 'grimshot --notify save active', mode "default"
        bindsym 2 exec 'grimshot --notify save area', mode "default"
        bindsym 3 exec 'grimshot --notify save output', mode "default"
        bindsym 4 exec 'grimshot --notify save window', mode "default"

        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym Mod4+Print mode "default"
      }
      bindsym Mod4+Print mode "$screenshot"
    '';
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
    '';
    config = rec {
      assigns = {
        "3" = [ { app_id = "virt-manager"; } { class = "zoom"; } ];
        "6" = [{ app_id = "gnucash"; }];
      };
      floating.modifier = "Mod4";
      modifier = "Mod4";
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
        };
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
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
          "Ctrl+Shift+l" = "exec 1password --ozone-platform-hint=auto --toggle";
          "Ctrl+Shift+space" = "exec 1password --ozone-platform-hint=auto --quick-access";
        };
      startup = [
        { command = "~/.config/sway/homescreen.sh"; }
        { command = "nm-applet --indicator"; }
        { command = "${pkgs._1password-gui}/bin/1password --ozone-platform-hint=auto --silent"; }
        # { command = "${pkgs._1password-gui}/bin/1password --silent"; }
        { command = "pcloud"; }
        { command = "mako"; }
        { command = "wl-paste -t text --watch clipman store --no-persist"; }
      ];

    };
  };
}
