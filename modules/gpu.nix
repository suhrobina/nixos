{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true; # no longer supported
    driSupport32Bit = true;
   };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    
    # To determine the GPUs' Bus IDs, use 'lspci' from the 'pciutils' package
    # $ lspci | grep ' VGA '
    prime = {
      # Method 1: SYNC mode - The Dedicated GPU runs at all times to
      #                       improve game performance
      #sync.enable = true;

      # Method 2: OFFLOAD mode - The Dedicated GPU is only enabled when needed
      #                          to optimize power consumption
      #                          - Console: $ nvidia-offload some-game
      #                          -   Steam:   nvidia-offload %command%
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Integrated
      intelBusId = "PCI:0:2:0";
      #amdgpuBusId = "PCI:0:0:0";
      
      # Dedicated
      nvidiaBusId = "PCI:1:0:0";
    };

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}   