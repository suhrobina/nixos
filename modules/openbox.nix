{ config, pkgs, ... }:

{
  # Enable OpenBox WM
  services.xserver.windowManager.openbox.enable = true;

  environment.systemPackages = with pkgs; [
    openbox-menu
    obconf
    tint2
    nitrogen
  ];
}
