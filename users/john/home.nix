{ config, pkgs, lib,... }:

{
  imports = [
    ./foot.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "john";
    homeDirectory = "/home/john";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "${pkgs.emacs}/bin/emacsclient -c";
    };
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 22;
    };
    file = {
      ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
      ".config/chromium-flags.conf".source = ./chromium-flags.conf;
      ".config/electron-flags.conf".source = ./electron-flags.conf;
      ".config/hypr/hyprland.conf".source = ./hyprland.conf;
      ".config/i3/config".source = ./i3-config;
      ".config/sway/grimshot.sh".source = ./sway/grimshot.sh;
      ".config/sway/homescreen.sh".source = ./sway/homescreen.sh;
      ".mbsyncrc".source = ./mbsyncrc;
      ".config/mutt" = {
        source = ./mutt;
        recursive = true;
      };
      ".config/ranger" = {
        source = ./ranger;
        recursive = true;
      };
      ".config/tmux/tmux.conf".source = ./tmux.conf;
      ".vimrc".source = ./vimrc;
    };
    packages = with pkgs; [
      #    _1password-gui
      bibata-cursors
      brightnessctl
      clipman
      digikam
      dolphin
      emacs
      fd
      firefox-wayland
      font-awesome
      ghostscript
      gnucash
      hack-font
      inconsolata
      isync
      libsForQt5.breeze-qt5
      libsForQt5.breeze-icons
      # libsForQt5.kaccounts-integration
      # libsForQt5.kaccounts-providers
      # libsForQt5.kio-gdrive
      # libsForQt5.kwallet
      # libsForQt5.qqc2-breeze-style
      # kwallet-pam
      # kwalletcli
      mako
      networkmanagerapplet
      noto-fonts
      pass
      pcloud
      picmi
      pinentry-curses
      # polkit-kde-agent
      qt5ct
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
    stateVersion = "22.11";
  };
  
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Screenshots";
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" ];
    historySize = 100000;
    initExtra = ''
      bind '"\e[A": history-search-backward'
      bind '"\eOA": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\eOB": history-search-forward'
    '';
    shellAliases = {
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ip = "ip -color=auto";
    };
    sessionVariables = {
      RESTIC_PASSWORD_COMMAND = "${pkgs.pass}/bin/pass backup/pluto";
#      WORKON_HOME = ~/src;
      SSH_AUTH_SOCK = /run/user/1000/keyring/ssh;
      LESS = "-R";
      # QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      # PLASMA_USE_QT_SCALING = 1;
      QT_QPA_PLATFORMTHEME = "qt5ct";
      VDPAU_DRIVER = "va_gl";
    };
    profileExtra = ''
      if [ -z "''${DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
      exec sway
      fi
    '';
  };
  
  # programs.emacs = {
  #   enable = true;
  #   extraPackages = epkgs: [
  #     epkgs.nix-mode
  #     epkgs.magit
  #   ];
  # };

  services.emacs = {
    enable = true;
  #   defaultEditor = true;
  #   socketActivation.enable = true;
  #   startWithUserSession = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "John Lord";
    userEmail = "john@lordsonline.org";
    extraConfig = {
      core.editor = "${pkgs.emacs}/bin/emacsclient -c";
      pull.rebase = "false";
    };
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
  
  programs.waybar = {
    enable = true;
    style = ./waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["sway/workspaces" "sway/mode" "custom/media"];
        modules-center = ["clock"];
        modules-right = ["idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "sway/language" "battery" "tray"];

       "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
	          "6" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        keyboard-state = {
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
	        on-click = "";
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        tray = {
          # icon-size = 21;
          spacing = 10;
        };
        "sway/language" = {
          on-click = "";
        };
        memory = {
          format = "{}% ";
	        on-click = "";
        };
        temperature = {
          # thermal-zone = 2;
          # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          # format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
	        on-click = "";
        };
        battery = {
          states = {
            # good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # format-good = ""; # An empty format will hide the module
                                 # format-full = "";
          format-icons = ["" "" "" "" ""];
        };
        network = {
          interface = "wl*"; # (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname} = {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname} = {ipaddr}/{cidr}";
        };
        "network#net2" = {
          interface = "tun*"; # (Optional) To force the use of this interface
          format-ethernet = "{}";
          format-disconnected = "";
          format-alt = "{ifname} = {ipaddr}/{cidr}";
        };    
        pulseaudio = {
          # scroll-step = 1; # %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
  }; 
#    mpd = {
#        format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
#        format-disconnected = "Disconnected ";
#        format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
#        unknown-tag = "N/A";
#        interval = 2;
#        "consume-icons" = {
#            on = " "
#        };
#        random-icons = {
#            off = "<span color=\"#f53c3c\"></span> ";
#            on = " "
#        };
#        repeat-icons = {
#            "on = " "
#        };
#        single-icons = {
#            on = "1 "
#        };
#        state-icons = {
#            paused = "";
#            playing = ""
#        };
#        tooltip-format = "MPD (connected)";
#        tooltip-format-disconnected = "MPD (disconnected)"
#    };
#        }
#    };
#    custom/media = {
#        format = "{icon} {}";
#        return-type = "json";
#        max-length = 40;
#        "format-icons = {
#            spotify = "";
#            default = "🎜"
#        };
#        escape = true;
#        exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" # Script in resources folder
#        # exec = "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" # Filter player based on name
#    }

  
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraConfig = builtins.readFile ./sway/config;
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
    '';
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
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
          #mod = wayland.windowManager.sway.config.modifier;
          mod = "Mod4";
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
        };
      startup = [
        # { command = "firefox"; }
        # { command = "emacsclient -c"; }
        # { command = "foot"; }
        { command = "~/.config/sway/homescreen.sh"; }
        { command = "nm-applet --indicator"; }
        { command = "1password --ozone-platform-hint=auto --silent"; }
        { command = "pcloud"; }
        { command = "mako"; }
        { command = "wl-paste -t text --watch clipman store --no-persist"; }
      ];

    };
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

}

