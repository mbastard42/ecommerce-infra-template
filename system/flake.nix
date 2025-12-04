{
  description = "ecommerce-infra-template - NixOS preprod";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.preprod = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        secret = import ../preprod/secret.nix;
      };

      modules = [
        
        {
          repo.dir = "/srv/vp/ecommerce-infra-template";
        }

        ../preprod/hardware-configuration.nix
        ../preprod/gandicloud.nix
        ../preprod/host.nix

        ./modules/frontend.nix
        ./modules/backend.nix
        ./modules/admin.nix
        ./modules/minio.nix
        ./modules/postgres.nix
      ];
    };
  };
}
