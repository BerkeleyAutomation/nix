{ ... }:

{
  imports = [
    ./hardware.nix
    ../profiles/docker.nix
  ];

  networking.hostName = "r2d2";
  system.stateVersion = "23.05";

  age.secrets.do-cert-creds.file = ../secrets/secret1.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "oliverni@berkeley.edu";

    certs."idm.berkeleyautomation.net" = {
      dnsProvider = "digitalocean";
      credentialsFile = age.secrets.do-cert-creds.path;
    };
  };

  virtualisation.oci-containers.containers.kanidm = {
    backend = "docker";
  };
}
