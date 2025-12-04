{
  modules = rec {

    common = args@{ config, pkgs, lib, ... }: let

      frontendStatic = pkgs.stdenv.mkDerivation {
        pname = "frontend-static";
        version = "0.1.0";

        src = ./svelte;

        buildInputs = [ pkgs.nodejs_22 ];

        buildPhase = ''
          npm ci
          npm run build
        '';

        installPhase = ''
          mkdir -p $out
          cp -r build $out/
        '';
      };
    in {
      services.frontend.staticRoot = "${frontendStatic}/build";
    };

    dev = args@{ config, pkgs, lib, ... }:
      lib.mkMerge [
        (common args)
        {
          systemd.services."frontend-dev" = {
            description = "Frontend (SvelteKit) dev server";
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];

            serviceConfig = {
              WorkingDirectory = "${repoDir}/system/services/frontend/svelte";
              ExecStart = "${pkgs.nodejs_22}/bin/npm run dev -- --host 0.0.0.0";

              Restart = "always";
              RestartSec = 2;
            };
          };

          networking.firewall.allowedTCPPorts = [ 5173 ];
        }
      ];

    prod = args@{ config, pkgs, lib, ... }:
      lib.mkMerge [
        (common args)
        {
          services.caddy = {
            enable = true;

            virtualHosts."localhost" = {
              extraConfig = ''
                root * ${config.services.frontend.staticRoot}
                encode gzip
                file_server
              '';
            };
          };

          networking.firewall.allowedTCPPorts = [ 80 443 ];
        }
      ];
  };
}