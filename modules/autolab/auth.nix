{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.autolab.auth;
in
{
  imports = [ ./auth/server.nix ];

  options.autolab.auth = {
    enable = mkEnableOption "Enable auth configuration";
  };

  config = mkIf cfg.enable {
    services.kanidm = {
      enableClient = true;
      enablePam = true;

      clientSettings = {
        uri = "https://idm.berkeleyautomation.net";
        verify_ca = true;
        verify_hostnames = true;
      };

      unixSettings = {
        pam_allowed_login_groups = [ "autolab_active" ];
        home_prefix = "/home/";
        home_attr = "uuid";
        home_alias = "name";
        use_etc_skel = true;
        uid_attr_map = "name";
        gid_attr_map = "name";
        selinux = false;
        allow_local_account_override = [ ];
      };
    };

    # sshd doesn't like /nix/store for some reason, so we need to wrap the
    # kanidm_ssh_authorizedkeys script so that it gets run properly
    environment.etc."ssh/kanidm_ssh_authorizedkeys_wrapper" = {
      mode = "0555";
      text = ''
        #!/bin/sh
        ${pkgs.kanidm}/bin/kanidm_ssh_authorizedkeys $1
      '';
    };

    services.openssh.authorizedKeysCommand = "/etc/ssh/kanidm_ssh_authorizedkeys_wrapper %u";
    services.openssh.authorizedKeysCommandUser = "nobody";
  };
}
