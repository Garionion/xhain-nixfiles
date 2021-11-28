{ config, ... }:

{
  users.users.nginx.extraGroups = [ "acme" ];
  users.users.nginx.isSystemUser = true;
  security.acme = {
    email = "acme-xhain@luepke.email";
    acceptTerms = true;
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  secrets.htpasswd.owner = "nginx";
  services.nginx = {
    enable = true;
    statusPage = true;
    virtualHosts.${config.networking.hostName + "." + config.networking.domain} = {
      enableACME = true;
      forceSSL = true;
      basicAuthFile = config.secrets.htpasswd.path;
      extraConfig = ''
        satisfy  any;
        allow ::1/128;
        allow 127.0.0.1/32;
        allow 40.158.40.192/32;
        deny all;
      '';
    };
  };
}
