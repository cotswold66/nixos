{ pkgs, ... }:
{
  programs.lieer.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    new.tags = [ "new" ];
    hooks = {
      preNew = ''
        cd /home/john/Maildir/business && gmi sync
        cd /home/john/Maildir/personal && gmi sync
      '';
      postNew = ''
        notmuch tag -new +business -- tag:new and path:business/**
        notmuch tag -new +personal -- tag:new and path:personal/**
      '';
    };
  };
  accounts.email = {
    accounts.business = {
      address = "john@lordpharmaconsulting.com";
      flavor = "gmail.com";
      lieer = {
        enable = true;
        sync.enable = true;
        settings = {
          replace_slash_with_dot = true;
          ignore_tags = [ "new" "business" ];
        };
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = false;
      realName = "John Lord";
      signature = {
        text = ''
          John Lord
        '';
        showSignature = "append";
      };
      passwordCommand = "pass imap.gmail.com\:587/john@lordpharmaconsulting.com";
    };
    accounts.personal = {
      address = "john@lordsonline.org";
      flavor = "gmail.com";
      lieer = {
        enable = true;
        sync.enable = true;
        settings = {
          replace_slash_with_dot = true;
          ignore_tags = [ "new" "personal" ];
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
    };
  };
}
