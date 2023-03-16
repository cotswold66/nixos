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

  home-manager.users.john = { pkgs, ... }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };
    
    home = {
      stateVersion = "22.11";
      username = "john";
      homeDirectory = "/home/john";
      sessionPath = [
        "$HOME/.local/bin"
      ];
    };
    
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
    };
  };
}
