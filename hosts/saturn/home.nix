{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      emacs-nox
    ];
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  sessionVariables = {
    LESS = "-R";
    SSH_AUTH_SOCK=/run/user/1000/keyring/ssh; # Needed for magit
  };
}
