{ config, pkgs, ... }:

{
  hardware = {
    graphics.enable = true;
    #nvidia.modesetting.enable = true;
  };

  programs.hyprland= {
    enable = true;
    xwayland.enable = true;
  };

  # GTK+ Bluetooth Manager
  services.blueman.enable = true;

  # Main Browser
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-hyprland

    playerctl
    brightnessctl

    waybar
    rofi-wayland
    kalker
    tmux
    kitty kitty-themes
    networkmanagerapplet # nm-applet
    btop
    nethogs
    pulsemixer

    # File Manager Yazi with additional features
    yazi ffmpeg p7zip jq poppler fd ripgrep fzf zoxide imagemagick xclip wl-clipboard xsel

    # Hypr Ecosystem
    hyprpaper
    hyprlock
    hypridle
    hyprshade
    hyprpolkitagent
  ];

  fonts.packages = with pkgs; [
    nerdfonts     # Default font
    font-awesome  # Default font for Waybar
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSES = "1";
    NIXOS_ONLINE_WL = "1";
    MOZ_ENABLE_WAYLAND="1"; # for screensharing
  };
}
