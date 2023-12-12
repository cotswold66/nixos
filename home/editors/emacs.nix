{ config, pkgs,  ...}:

let 
  my-emacs = ((pkgs.emacsPackagesFor pkgs.emacs29-pgtk).emacsWithPackages (
    epkgs: [ epkgs.notmuch ])
  );
in
{  
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
}
