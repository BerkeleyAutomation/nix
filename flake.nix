{
  description = "NixOS Configuration for AUTOLab";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/23.05;
    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus/v1.3.1;
    agenix.url = "github:ryantm/agenix/0.14.0";
  };

  outputs = inputs@{ self, flake-utils-plus, agenix, ... }:
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];
      hostDefaults.modules = [
        ./profiles/base.nix
        agenix.nixosModule
      ];

      hosts.r2d2.modules = [ ./hosts/r2d2 ];
    };
}
