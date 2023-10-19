{
  description = "NixOS Configuration for AUTOLab";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus/v1.4.0;
    agenix.url = "github:ryantm/agenix/0.14.0";
  };

  outputs = inputs@{ self, flake-utils-plus, agenix, ... }:
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];
      hostDefaults.modules = [
        ./profiles/base.nix
        agenix.nixosModules.default
      ];

      hosts.r2d2.modules = [ ./hosts/r2d2 ];
    };
}
