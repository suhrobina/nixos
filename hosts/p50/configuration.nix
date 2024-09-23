# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports =
    [
      # ==| NixOS Profiles |===================================================
      # NixOS profiles for different hardware. Check 'https://github.com/NixOS/nixos-hardware.git'
      # OPTION 1: Fetch the git repo directly for specific hardware
         #"${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/p50"
      # OPTION 2: Include the local downloaded configuration
         ../../nixos-hardware/lenovo/thinkpad/p50
      # OPTION 3: Include the local configuration for hardware that is not on the list
      #
      # =======================================================================

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home-manager.nix
      ../../modules/virtualisation.nix
      ../../modules/gaming.nix
      #../../modules/gpu.nix
      ../../modules/nixvim.nix
      ../../modules/zsh.nix
    ];

  # Enable/Disable imported modules
  zsh.enable = true;
  virtualisation.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Dushanbe";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tg_TJ.UTF-8";
    LC_IDENTIFICATION = "tg_TJ.UTF-8";
    LC_MEASUREMENT = "tg_TJ.UTF-8";
    LC_MONETARY = "tg_TJ.UTF-8";
    LC_NAME = "tg_TJ.UTF-8";
    LC_NUMERIC = "tg_TJ.UTF-8";
    LC_PAPER = "tg_TJ.UTF-8";
    LC_TELEPHONE = "tg_TJ.UTF-8";
    LC_TIME = "tg_TJ.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.suhrob = {
    isNormalUser = true;
    description = "Suhrob R. Nuraliev";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Define specific rules to be in the sudoers file
  security.sudo.extraRules = [{
    users = ["suhrob"];
    commands = [{ command = "ALL";
      options = ["NOPASSWD"];
      }];
  }];

  # ==| PACKAGES |=============================================================

  # Main browser
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Base
    #home-manager

    # Utilites
    git
    lshw pciutils
    wget curl
    zip unzip gzip
    htop btop
    tmux
    tldr
    fastfetch
    ncdu
    eza
    inxi
    thefuck

    # Networking
    nethogs
    winbox
    wireguard-tools # Configure connection via nmcli, nmtui and native wg

    # File-Manager
    nnn mc yazi

    # Note Taking App
    qownnotes

    # Editor
    vscode

    # Terminal
    kitty kitty-themes

    # Internet
    telegram-desktop
    remmina
    transmission_4-gtk

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US

    # Fun
    cmatrix
    cowsay
    hollywood
    cool-retro-term

    # Others
    just
    pomodoro-gtk
  ];

  # --| Transmission |---------------------------------------------------------
  #
  # Declare Download dir
  services.transmission.settings = {
    download-dir = "${config.services.transmission.home}/Downloads";
  };
  ## Allow remote access
  #services.transmission = {
  #    enable = true;                          #Enable transmission daemon
  #    openRPCPort = true;                     #Open firewall for RPC
  #    settings = {                            #Override default settings
  #      rpc-bind-address = "0.0.0.0";         #Bind to own IP
  #      rpc-whitelist = "127.0.0.1,10.0.0.1"; #Whitelist your remote machine (10.0.0.1 in this example)
  #    };
  #  };
  # ---------------------------------------------------------------------------

  # --| LibreOffice |----------------------------------------------------------
  #
  ## uno Python Library for specific path '/lib/libreoffice/program'
  #let
  #  office = pkgs.libreoffice-fresh-unwrapped;
  #in {
  #  environment.sessionVariables = {
  #    PYTHONPATH = "${office}/lib/libreoffice/program";
  #    URE_BOOTSTRAP = "vnd.sun.star.pathname:${office}/lib/libreoffice/program/fundamentalrc";
  #  };
  #}
  # ---------------------------------------------------------------------------

  # ===========================================================================

  environment.variables = {
    BROWSER="firefox";
    FILE="yazi";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?


  # ==| OTHERs |===============================================================

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable firmware with a license allowing redistribution
  hardware.enableAllFirmware = true;

  # Set Environment Variables
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # disabled due to errors while builiding
  systemd.services.NetworkManager-wait-online.enable = false;

  # The temperature management deamon
  services.thermald.enable = true;

  # Periodic SSD TRIM of mounted partitions in background
  services.fstrim.enable = true;

  # The swap file
  swapDevices = [ {
    device = "/32G.swapfile";
    size = 32*1024;
  } ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Without this option, WireGuard doesn't work
  networking.firewall.checkReversePath = "loose";


  # ==| FONTS |================================================================

  fonts.packages = with pkgs; [
    # Installing specific fonts from nerdfonts
    #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    nerdfonts
  ];

 # #----=[ Fonts ]=----#
 # fonts = {
 #   enableDefaultPackages = true;
 #   packages = with pkgs; [
 #     ubuntu_font_family
 #     liberation_ttf
 #     # Persian Font
 #     vazir-fonts
 #   ];
 #
 #   fontconfig = {
 #     defaultFonts = {
 #       serif = [  "Liberation Serif" "Vazirmatn" ];
 #       sansSerif = [ "Ubuntu" "Vazirmatn" ];
 #       monospace = [ "Ubuntu Mono" ];
 #     };
 #   };
 # };
  # ===========================================================================

}

