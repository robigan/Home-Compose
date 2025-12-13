{ config, pkgs, lib, ... }:

with lib; 
let
  cfg = config.customization;
in {
  options.customization = {
    tz = mkOption {
      type = types.str;
      default = "Europe/Amsterdam";
      description = ''
        Set the system time zone, e.g. "America/New_York" or "Europe/Amsterdam".
      '';
    };

    keyMap = mkOption {
      type = types.str;
      default = "us";
      description = ''
        Set the console key map, e.g. "us", "de", "fr", "be-latin1", ...
      '';
    };
  };

  config = {
    ### BASIC SYSTEM CONFIGURATION ###
    # Set your time zone.
    time.timeZone = cfg.tz;
    
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      keyMap = cfg.keyMap;
    };

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
      git
      curl
      nano
      vi
      unzip
      gnutar
      htop
    ];

    ### SERVICES ###
    # Docker section
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      enableOnBoot = true;
      daemon.settings = {
        default-address-pools = [
          {
            base = "172.17.0.0/12";
            size = 20;
          }
        ];
      };
    };

    # Enable the Cockpit service for management.
    services.cockpit = {
      enable = true;
      port = 9090;
      openFirewall = true;
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      settings.PrintMotd = true;
      # Harden settings
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "no";
      # settings.AllowUsers = [ "alta" ];
    };

    ### NETWORKING ###
    # Enable firewall with some basic rules.
    networking.firewall.enable = true;
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ 22 ];
    # networking.firewall.allowedUDPPorts = [ 22 ];
  };
}