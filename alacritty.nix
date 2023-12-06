{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = {
          columns = 90;
          lines = 40;
        };
      };
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Regular";
        };
        bold = {
          family = "Source Code Pro";
          style = "Bold";
        };
        italic = {
          family = "Source Code Pro";
          style = "Italic";
        };
        bold-italic = {
          family = "Source Code Pro";
          style = "Bold Italic";
        };
        size = 11.0;
      };
    };
  };
}
