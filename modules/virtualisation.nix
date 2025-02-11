{ config, pkgs, lib,  ... }: {

  options = {
    virtualisation.enable = lib.mkEnableOption "enables Virtualisation";
  };

  config = lib.mkIf config.virtualisation.enable {
    programs.dconf.enable = true;

    users.users.suhrob.extraGroups = [ "libvirtd" ];

    # Required packages
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
          vhostUserPackages = [ pkgs.virtiofsd ];
          #runAsRoot = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;


    # The default network starts off as being inactive, you must enable it
    # before it is accessible.This can be done by running the following command:
    # The default network starts off as being inactive, you must enable it before
    # it is accessible.
    # This can be done by running the following commands:
    #     $ virsh net-start default
    #     $ virsh net-autostart default
    system.activationScripts.startVirshNetwork = {
      text = ''
        # Check 'default' network status
        NETWORK_STATUS=$(${pkgs.libvirt}/bin/virsh net-info default | grep "Active" | cut -d ':' -f2 | tr -d ' ')
        # If 'default' network not active, activate it and mark as autostart
        if [ "$NETWORK_STATUS" != "yes" ]; then
          echo "Network 'default' is not active. Starting..."
          ${pkgs.libvirt}/bin/virsh net-start default
          ${pkgs.libvirt}/bin/virsh net-autostart default
        else
          echo "Network 'default' is already running."
        fi
      '';
    };
  };
}

