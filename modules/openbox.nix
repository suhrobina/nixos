{ config, pkgs, ... }:

{
  # Enable OpenBox WM
  services.xserver.windowManager.openbox.enable = true;

  # Configure lid begavior
#  services.logind = {
#    lidSwitch = "ignore";              # Do nothing when lid is closed (on battery or AC)
#    lidSwitchDocked = "ignore";        # Do nothing when docked
#    lidSwitchExternalPower = "ignore"; # Do nothing when on external power
#  };

  environment.systemPackages = with pkgs; [
    obconf
    tint2
    nitrogen
    xlockmore
  ];
}
