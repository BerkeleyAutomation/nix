{ lib, ... }:

{
  imports = [
    ../hardware/hetzner-38345231.nix
  ];

  autolab.auth.server = {
    enable = true;
    domain = "idm.berkeleyautomation.net";
    origin = "https://idm.berkeleyautomation.net";
  };

  boot.loader = {
    systemd-boot.enable = false;
    grub.enable = true;
    grub.devices = [ "/dev/sda" ];
  };

  networking.hostName = "bumblebee";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
