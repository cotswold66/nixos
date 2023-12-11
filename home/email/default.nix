{ pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  accounts.email = {
    accounts.business = {
      address = "john@lordpharmaconsulting.com";
      flavor = "gmail.com";
      lieer = {
        enable = true;
        sync.enable = true;
      };
      # mbsync = {
      #   enable = true;
      #   create = "maildir";
      #   expunge = "maildir";
        # flatten = ".";
        # patterns = [ "[Gmail]/All Mail" ];
        # extraConfig = {
        #   channel = {
        #     Sync = [ "Pull" "New" "ReNew" "Delete" "Flags" ];
        #     SyncState = "*";
        #     CopyArrivalDate = "yes";
        #   };
      # };
      # };
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
      passwordCommand = "pass imap.gmail.com\:587/john@lordpharmaconsulting.com";
    };
  };
}
