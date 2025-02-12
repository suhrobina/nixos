# NOTE: There are three ways to install Home Manager. In this case, it is used as a
# module within a NixOS system configuration. This configuration file directly
# downloads the required version and uses it without adding a channel.
{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in

{
  imports = [
    (import "${home-manager}/nixos")
  ];


  users.users.suhrob.isNormalUser = true;

  home-manager.users.suhrob = { pkgs, ... }: {

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11";

    # VSC options
    programs.git = {
      enable = true;
      userEmail = "LongOverdueVitalEnergy@GMail.com";
      userName = "Suhrob R. Nuraliev";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    # To check GTK setting, run `nwg-look`
    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
      };
      font = {
        package = pkgs.nerdfonts;
        name = "IosevkaTerm Nerd Font";
        size = 12;
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      theme = {
        package = pkgs.shades-of-gray-theme;
        name = "Shades-of-gray-Harvest";
      };
    };

    home.pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    # To check GTK setting, run `qt5ct` or `qt6ct`
    qt = {
      enable = true;
      style = {
        #package = pkgs.adwaita-qt;
        name = "Fusion";
      };
    };

    home.packages = [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      # GTK Settings Editor
      pkgs.nwg-look

      # QT5/QT6 Configuration Tool
      pkgs.libsForQt5.qt5ct
      pkgs.kdePackages.qt6ct
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
#      ".config/kitty/kitty.conf".source = ./home/.config/kitty/kitty.conf;
#      ".config/hypr/hyprland.conf".source = ./home/.config/hypr/hyprland.conf;
#      ".config/waybar/config".source = ./home/.config/waybar/config;
#       "/home/suhrob/.config/test.txt".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/hosts/p50/dotfiles/test.txt";

#      home.file.".config/test.txt" = {
#        source = "/etc/nixos/hosts/p50/dotfiles/test.txt";
#        #recursive = true;
#      };

    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/suhrob/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24";
      GTK_CURSOR_THEME = "Adwaita";
      GTK_CURSOR_SIZE = "24";
    };

  };
}
