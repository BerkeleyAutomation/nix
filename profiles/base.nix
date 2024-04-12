{ lib, pkgs, ... }:

{
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

  autolab = {
    auth.enable = lib.mkDefault true;
    locale.enable = lib.mkDefault true;
    shell.enable = lib.mkDefault true;
    tailscale.enable = lib.mkDefault true;
  };

  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };

    envfs = {
      enable = true;
      extraFallbackPathCommands = ''
        ln -s ${pkgs.bash}/bin/bash $out/bash
        ln -s ${pkgs.zsh}/bin/zsh $out/zsh
        ln -s ${pkgs.fish}/bin/fish $out/fish
        ln -s ${pkgs.xonsh}/bin/xonsh $out/xonsh
      '';
    };
  };

  programs = {
    nix-ld.enable = true;
    tmux.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
