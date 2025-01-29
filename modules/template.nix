{ config, pkgs, lib,  ... }: {

  options = {
    THE_MODULE.enable = lib.mkEnableOption "enables THE_MODULE";
  };

  config = lib.mkIf config.THE_MODULE.enable {
    # HERE SHOULD BE CONFIGURATION
  };
}
