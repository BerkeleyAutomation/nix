{ modulesPath, pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  environment.systemPackages = [
    pkgs.vim
  ];

  system.stateVersion = "23.05";
}
