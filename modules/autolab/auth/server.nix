{ lib, config, ... }:

with lib;
let
  cfg = config.autolab.auth.server;
in
{
  options.autolab.auth.server = {
    enable = mkEnableOption "Enable auth server";
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to open the firewall for the auth server";
    };
    domain = mkOption {
      type = types.str;
      description = "The domain name for the auth server";
    };
    origin = mkOption {
      type = types.str;
      description = "The origin for the auth server";
    };
  };

  config = mkIf cfg.enable {
    services.kanidm = {
      enableServer = true;

      serverSettings = {
        bindaddress = "[::]:443";
        ldapbindaddress = "[::]:3636";
        tls_chain = "/var/lib/acme/${cfg.domain}/fullchain.pem";
        tls_key = "/var/lib/acme/${cfg.domain}/key.pem";
        domain = cfg.domain;
        origin = cfg.origin;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 443 3636 ];

    age.secrets.cf-cert-creds.file = ../../../secrets/cf-cert-creds.age;

    security.acme = {
      acceptTerms = true;
      defaults.email = "oliverni@berkeley.edu";

      certs.${cfg.domain} = {
        dnsProvider = "cloudflare";
        credentialsFile = config.age.secrets.cf-cert-creds.path;
        group = "kanidm";
      };
    };
  };
}
