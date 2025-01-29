{ config, pkgs, ... }:

{
  hardware = {
    opengl.enable = true;
    #nvidia.modesetting.enable = true;
  };

  programs.hyprland= {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-hyprland
    wofi
    waybar
    hyprshade
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSES = "1";
    NIXOS_ONLINE_WL = "1";
    MOZ_ENABLE_WAYLAND="1"; # for screensharing
  };
}
