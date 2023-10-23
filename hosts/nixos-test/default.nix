{ modulesPath, pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  system.stateVersion = "23.05";
}
