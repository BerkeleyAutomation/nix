{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.autolab.shell;
in
{
  options.autolab.shell = {
    enable = mkEnableOption "Enable shell configuration";
  };

  config = mkIf cfg.enable {
    environment = {
      enableAllTerminfo = true;
      systemPackages = with pkgs; [
        zsh
        zsh-powerlevel10k
      ];
    };

    programs.zsh = {
      enable = true;
      shellInit = ''
        zsh-newuser-install() { :; }
      '';
      interactiveShellInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./shell/p10k.zsh}
      '';
    };

    services.kanidm.unixSettings.default_shell = "${pkgs.zsh}/bin/zsh";

    users = {
      defaultUserShell = pkgs.zsh;
      motd = builtins.readFile ./shell/motd;
    };
  };
}
