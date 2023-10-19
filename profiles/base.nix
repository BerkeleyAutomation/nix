{ config, pkgs, ... }:

{
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  security.sudo.wheelNeedsPassword = false;
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.oliver = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlViRB5HH1bTaS1S7TcqVBSuxKdrbdhL2CmhDqc/t6A oliver.ni@gmail.com"
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    tmux
    htop
  ];
}
