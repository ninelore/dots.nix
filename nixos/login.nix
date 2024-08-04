{ inputs, pkgs, ... }:
{
  # required for defaultSession
  #programs.hyprland = {
  #  enable = true;
  #  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #  xwayland.enable = true;
  #};

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      defaultSession = "plasma";
    };
  };

  security = {
    polkit.enable = true;
  };
}
