{ config, pkgs, ... }:

let
  attributes = {
    user = "john";
    repository = b2:jl-restic;
    initialize = true;
    passwordFile = config.sops.secrets.restic-repo-password.path;
    environmentFile = config.sops.secrets.b2-credentials.path;
    paths = [ "/home/john" ];
    exclude = [
      "$HOME/*"
      "!$HOME/Desktop"
      "!$HOME/Documents"
      "!$HOME/gnucash"
      "!$HOME/Inbox"
      "!$HOME/Maildir"
      "!$HOME/Music"
      "!$HOME/Pictures"
      "!$HOME/Public"
      "!$HOME/Screenshots"
      "!$HOME/src"
      "!$HOME/Templates"
      "!$HOME/Videos"
      "!$HOME/Zotero"
      "!$HOME/.gnupg"
      "!$HOME/.gramps"
      "!$HOME/.ssh"
      
      "!$HOME/.emacs.d"
      "$HOME/.emacs.d/*"
      "!$HOME/.emacs.d/bookmarks"
      "!$HOME/.emacs.d/projects"
      
      "!$HOME/.config"
      "$HOME/.config/*"
      "!$HOME/.config/kshisenrc"
      "!$HOME/.config/picmirc"
      
      "!$HOME/.local"
      "$HOME/.local/*"
      
      "!$HOME/.local/share"
      "$HOME/.local/share/*"
      "!$HOME/.local/share/gnome-mines"
    ];
    pruneOpts = [
      "--keep-last    1"
      "--keep-hourly  2" 
      "--keep-daily   7" 
      "--keep-weekly  4"
      "--keep-monthly 12"
      "--keep-yearly  5"
    ];
  }; 
in
{
  sops = {
    secrets.restic-repo-password = {
      owner = config.users.users.john.name;
    };
    secrets.b2-credentials = {
      owner = config.users.users.john.name;
    };
  };

  services.restic.backups.b2 = attributes;
  services.restic.backups.saturn = attributes // {
    repository = "rest:http://192.168.1.2:8000/";
    environmentFile = null;
  };
}

