{
  description = "NixOS Configuration for AUTOLab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, agenix }:
    let
      # ========================
      # NixOS Host Configuration
      # ========================

      # Put modules common to all hosts here.
      commonModules = [
        agenix.nixosModules.default
        ./profiles/base.nix
      ];

      # Put modules for specific hosts here.
      hosts = {
        bumblebee = [ ./hosts/bumblebee.nix ];
        nixos-test = [ ./hosts/nixos-test.nix ];
      };

      # =====================
      # nixpkgs Configuration
      # =====================

      overlays = [
        agenix.overlays.default
      ];

      # =====================
      # Colmena Configuration
      # =====================

      pkgs-x86_64-linux = import nixpkgs {
        inherit overlays;
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      };

      colmena = builtins.mapAttrs
        (host: modules: {
          imports = commonModules ++ modules;
          deployment.buildOnTarget = true;
          deployment.targetUser = "oliver";
          deployment.allowLocalDeployment = true;
        })
        hosts;

      colmenaOutputs = {
        colmena = colmena // {
          meta = { nixpkgs = pkgs-x86_64-linux; };
        };
      };

      # =======================
      # Dev Shell Configuration
      # =======================

      devShellOutputs = flake-utils.lib.eachDefaultSystem (system:
        let pkgs = import nixpkgs { inherit system overlays; }; in {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.colmena
              pkgs.agenix
            ];
          };
        }
      );
    in
    colmenaOutputs // devShellOutputs;
}
