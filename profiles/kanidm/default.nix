{ config, ... }:

{
  environment.etc = {
    "kanidm/server.toml".source = ./server.toml;
  };

  age.secrets.cf-cert-creds.file = ../../secrets/cf-cert-creds.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "oliverni@berkeley.edu";

    certs."idm.berkeleyautomation.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cf-cert-creds.path;
    };
  };

  virtualisation.oci-containers.containers = {
    kanidm-server = {
      ports = [ "443:8443" "636:3636" ];
      image = "kanidm/server:latest";
      volumes = [
        "/var/lib/acme/idm.berkeleyautomation.net:/tls"
        "/var/lib/kanidm:/data"
        "/etc/kanidm/server.toml:/data/server.toml"
      ];
    };
  };
}
