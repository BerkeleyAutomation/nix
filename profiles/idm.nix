{ config, pkgs, ... }:

{
  services.kanidm = {
    enableServer = true;
    enableClient = true;

    serverSettings = {
      bindaddress = "[::]:443";
      ldapbindaddress = "[::]:3636";
      tls_chain = "/var/lib/acme/idm.berkeleyautomation.net/fullchain.pem";
      tls_key = "/var/lib/acme/idm.berkeleyautomation.net/key.pem";
      domain = "idm.berkeleyautomation.net";
      origin = "https://idm.berkeleyautomation.net";
    };

    clientSettings = {
      uri = "https://idm.berkeleyautomation.net";
      verify_ca = true;
      verify_hostnames = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 3636 ];

  age.secrets.cf-cert-creds.file = ../secrets/cf-cert-creds.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "oliverni@berkeley.edu";

    certs."idm.berkeleyautomation.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cf-cert-creds.path;
      group = "kanidm";
    };
  };
}
