{ config, pkgs, ... }:

{
  users.users.suhrob.extraGroups = [ "docker" ];

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # Changing Docker Daemon's Data Root
    #daemon.settings = {
    #  data-root = "/some-place/to-store-the-docker-data";
    #};
  };

  environment.systemPackages = with pkgs; [
    nvidia-docker
  ];
}
