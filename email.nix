{ pkgs, ... }:
{
  home-manager.users.john = { config, pkgs, ... }: {
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    programs.notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };
    accounts.email = {
      accounts.personal = {
        address = "john@lordsonline.org";
        flavor = "gmail.com";
        imap.host = "imap.gmail.com";
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "maildir";
          flatten = ".";
          patterns = [ "[Gmail]/All Mail" ];
          extraConfig = {
            channel = {
              Sync = [ "Pull" "New" "ReNew" "Delete" "Flags" ];
              SyncState = "*";
              CopyArrivalDate = "yes";
            };
          };
        };
        msmtp.enable = true;
        notmuch.enable = true;
        primary = true;
        realName = "John Lord";
        signature = {
          text = ''
          John Lord
        '';
          showSignature = "append";
        };
        passwordCommand = "pass imap.gmail.com\:587/john@lordsonline.org";
        smtp = {
          host = "smtp.gmail.com";
        };
        userName = "john@lordsonline.org";
      };
    };
  };
}
