{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Source Code Pro:size=12";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors = {
        background = "1d1f21";
        foreground = "c5c8c6";
        # normal
        regular0 = "1d1f21";
        regular1 = "cc6666";
        regular2 = "b5bd68";
        regular3 = "f0c674";
        regular4 = "81a2be";
        regular5 = "b294bb";
        regular6 = "8abeb7";
        regular7 = "c5c8c6";
        # bright
        bright0 = "969896";
        bright1 = "de935f";
        bright2 = "282a2e";
        bright3 = "373b41";
        bright4 = "b4b7b4";
        bright5 = "e0e0e0";
        bright6 = "a3685a";
        bright7 = "ffffff";
        # extended
        "16" = "de935f";
        "17" = "a3685a";
        "18" = "282a2e";
        "19" = "373b41";
        "20" = "b4b7b4";
        "21" = "e0e0e0";
        # misc
        selection-background = "c5c8c6";
        selection-foreground = "1d1f21";
        urls = "b4b7b4";
        jump-labels = "1d1f21 f0c674";
        scrollback-indicator = "1d1f21 b4b7b4";
      };
    };
  };
}
