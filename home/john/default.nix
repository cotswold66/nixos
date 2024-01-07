{ config, pkgs, inputs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "john";
    homeDirectory = "/home/john";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    packages = with pkgs; [
      mosh
      rsync
      tmux
    ];
    file = {
      ".local/bin/" = {
        source = ./files/restic;
        recursive = true;
      };
    };
  };

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

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
  };

  programs.home-manager.enable = true;

}
