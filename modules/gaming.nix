{ config, pkgs, ... }:

{
  # Optimize Linux system performance on demand
  programs.gamemode.enable = true;

  # Steam
  # use in steam game launch option:
  #   gamemoderun %command%
  #   mongohud %command%
  #   gamescope %command%
  environment.systemPackages = with pkgs; [
    # Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more
    mangohud

    # Run protonup from console to download latest GE Proton for Steam
    protonup

    #lutris
    #heroic
  ];
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;      # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.config/steam/root/compatibilitytools.d";
  };
}
