{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--disable-features=WaylandFractionalScaleV1"
    ];
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; }
    ];
  };
}
