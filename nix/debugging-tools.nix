{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.debug;
  cfgNet = cfg.networking;
in {
  options.debug = {
    networking = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable modification of system for network debug purposes. This includes installation of common networking debug tools such as arp, dig, and tcpdump.
        '';
      };

      tcpdumpNoPass = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable root access of networking interfaces with tcpdump without requiring a password.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "wheel";
          description = ''
            The group that should be granted access to passwordless networking interfaces with tcpdump.
          '';
        };
      };
    };
  };

  config = mkIf cfgNet.enable {
    environment.systemPackages = with pkgs; [
      # 'arp' is provided by net-tools
      nettools
      # 'dig' is provided by dnsutils
      dnsutils
      # 'tcpdump' is provided by tcpdump
      tcpdump
    ];

    # Allow members of the specified group to run tcpdump without a password
    # to access networking interfaces.
    security.sudo.extraRules = mkIf cfgNet.tcpdumpNoPass.enable [
      {
        groups = [ cfgNet.tcpdumpNoPass.group ];
        commands = [ 
          { 
            command = "${pkgs.tcpdump}/bin/tcpdump";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/tcpdump";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}