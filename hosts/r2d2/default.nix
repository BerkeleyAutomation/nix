{ config, ... }:

{
  imports = [
    ./hardware.nix
    ./networking.nix
    ../../profiles/docker.nix
    ../../profiles/kanidm
  ];

  networking.hostName = "r2d2";
  system.stateVersion = "23.05";
}
