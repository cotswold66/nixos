{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./chromium.nix
    ./foot.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  
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
      ".config/electron-flags.conf".source = ./electron-flags.conf;
      ".config/hypr/hyprland.conf".source = ./hyprland.conf;
      ".config/i3/config".source = ./i3-config;
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
    };
    packages = with pkgs; [
      # _1password-gui
      bibata-cursors
      brightnessctl
      clipman
      digikam
      dolphin
      emacs
      fd                        # Search engine for emacs
      firefox-wayland
      font-awesome              # Fonts used in waybar
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
      # libsForQt5.kaccounts-integration
      # libsForQt5.kaccounts-providers
      # libsForQt5.kio-gdrive
      # libsForQt5.kwallet
      # libsForQt5.qqc2-breeze-style
      # kwallet-pam
      # kwalletcli
      libreoffice-fresh
      mako
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
      # polkit-kde-agent
      qt5ct
      restic
      ripgrep                   # Needed for emacs search
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

  programs.vim = {
    enable = true;
    settings = {
      expandtab = true;
      hidden = true;
      history = 200;
      ignorecase = true;
      number = true;
      relativenumber = false;
      shiftwidth = 2;
      smartcase = true;
      tabstop = 2;
    };
    plugins = with pkgs.vimPlugins; [
      commentary
      ctrlp
      ranger-vim
      surround
      vim-airline
      vim-airline-themes
      vim-orgmode
    ];
    extraConfig = ''
      let skip_defaults_vim=1
      set nocompatible

      let &t_SI = "\e[6 q"
      let &t_SR = "\e[4 q"
      let &t_EI = "\e[2 q"

      let mapleader = " "

      set ruler

      set softtabstop=2
      set smartindent
      set smarttab
      set autoindent

      set listchars=tab:→\ ,eol:↲,nbsp:␣,space:·,trail:·,extends:⟩,precedes:⟨

      set textwidth=73 

      set nobackup
      set noswapfile
      set nowritebackup

      set icon

      set laststatus=2
      set statusline=%.40F\ %m\ %y
      set statusline+=%=        " Switch to the right side
      set statusline+=%l        " Current line
      set statusline+=/         " Separator
      set statusline+=%L        " Total lines

      set scrolloff=3

      set hlsearch
      set incsearch
      set linebreak
      map <silent> <leader><cr> :noh<cr>
      
      syntax enable
      
      set ttyfast
      
      set omnifunc=syntaxcomplete#Complete
      
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l
      
      filetype plugin indent on
      if has("autocmd")
        autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
      endif
      
      cmap W w !sudo tee % >/dev/null<CR>
      
      let g:airline_powerline_fonts=1
  '';
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

