{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.irssi;

in {
  options.modules.irssi.enable = mkEnableOption "Install and configure irssi";
  options.modules.irssi.user = mkOption {
    type = types.str;
    description = "Set the nick and name variable";
    default = "";
  };

  config = mkIf cfg.enable {
    programs.irssi = {
      enable = true;
      networks =
        {
          libera = {
            type = "IRC";
            nick = cfg.user;
            name = cfg.user;
            server = {
              address = "irc.libera.chat";
              port = 6697;
              autoConnect = false;
            };
            channels = {
              nixos.autoJoin = true;
            };
          };
        };
    };
  };
}
