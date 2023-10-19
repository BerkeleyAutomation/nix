{ config, ... }:

{
  imports = [
    ./hardware.nix
    ./networking.nix
    ../../profiles/docker.nix
  ];

  networking.hostName = "r2d2";
  system.stateVersion = "23.05";

  age.secrets.cf-cert-creds.file = ../../secrets/cf-cert-creds.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "oliverni@berkeley.edu";

    certs."idm.berkeleyautomation.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cf-cert-creds.path;
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
  };
}
