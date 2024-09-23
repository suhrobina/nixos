{ config, pkgs, lib,  ... }: {

  options = {
    THE_MODULE.enable = lib.mkEnableOption "enables THE_MODULE";
  };

  config = lib.mkIf config.zsh.enable {
    # HERE SHOULD BE CONFIGURATION
  };
}
