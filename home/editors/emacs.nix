{ config, pkgs,  ...}
  
  let 
    my-emacs = pkgs.emacs29-pgtk;
  in
    {
      programs.emacs = {
        enable = true;
        package = my-emacs;
        extraPackages = [
          mu4e
        ];
};
      
      services.emacs = {
        enable = true;
        client.enable = true;
        defaultEditor= true;
        package = my-emacs;
      };

      home.packages = with pkgs; [
        fd
        gcc
        ghostscript
        ripgrep
        source-code-pro
      ];
    };
};
