{ config, pkgs, lib, ... }:

{
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    # TODO: autoReplication
  };

  services.xserver = {
  	enable = true;
    
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
      
      sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
URxvt.font:      xft:Source Code Pro:Regular:size=12
*.cursorColor:   #5C6370
*.highlightColor:#3A3F4B
! Dracula Xresources palette
*.foreground: #F8F8F2
*.background: #282A36
*.color0:     #000000
*.color8:     #4D4D4D
*.color1:     #FF5555
*.color9:     #FF6E67
*.color2:     #50FA7B
*.color10:    #5AF78E
*.color3:     #F1FA8C
*.color11:    #F4F99D
*.color4:     #BD93F9
*.color12:    #CAA9FA
*.color5:     #FF79C6
*.color13:    #FF92D0
*.color6:     #8BE9FD
*.color14:    #9AEDFE
*.color7:     #BFBFBF
*.color15:    #E6E6E6
Xft*antialias:   true
URxvt.scrollBar: false
EOF
      '';
    };

    windowManager.xmonad= {
      enable = true;
      enableContribAndExtras = true;
    };
    
		layout = "de";
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts."buildserver.lambda.local" = {
      addSSL = false;
      enableACME = false;
      root = "/var/www/buildserver";
      serverAliases = [ "buildserver" ];
      locations."/".extraConfig = ''
        proxy_pass http://localhost:${toString config.services.nix-serve.port};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
  
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = true;
    hostKeys =
      [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
  };
}
