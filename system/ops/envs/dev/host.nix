{ config, pkgs, ... }:

{
  networking.hostName = "vp-preprod";

  time.timeZone = "Europe/Paris";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22  # SSH
      80  # HTTP
      443 # HTTPS
    ];
  };

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
