{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  wallpaper = "${inputs.media}/El Capitan 2.jpg";
  colorscheme = import ./colors.nix;
  fontConf = {
    names = [ "Inter" ];
    size = 11.0;
  };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        decorations = "none";
      };

      colors.primary = {
        background = "#${colorscheme.dark.bg_0}";
        foreground = "#${colorscheme.dark.fg_0}";
        dim_foreground = "#${colorscheme.dark.dim_0}";
      };

      colors.normal = {
        black = "#636363";
        red = "#${colorscheme.dark.red}";
        green = "#${colorscheme.dark.green}";
        yellow = "#${colorscheme.dark.yellow}";
        blue = "#${colorscheme.dark.blue}";
        magenta = "#${colorscheme.dark.magenta}";
        cyan = "#${colorscheme.dark.cyan}";
        white = "#f7f7f7";
      };

      colors.bright = {
        black = "#636363";
        red = "#${colorscheme.dark.br_red}";
        green = "#${colorscheme.dark.br_green}";
        yellow = "#${colorscheme.dark.br_yellow}";
        blue = "#${colorscheme.dark.br_blue}";
        magenta = "#${colorscheme.dark.br_magenta}";
        cyan = "#${colorscheme.dark.br_cyan}";
        white = "#f7f7f7";
      };
    };
  };

  services.mako = {
    enable = true;

    backgroundColor = "#${colorscheme.dark.bg_2}";
    borderColor = "#${colorscheme.dark.bg_1}";
    borderRadius = 12;
    progressColor = "#${colorscheme.dark.br_cyan}";
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}"; }
      { timeout = 600; command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\""; resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\""; }
    ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}"; }
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;

    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      fonts = fontConf;
      gaps = {
          bottom = 5;
          horizontal = 5;
          vertical = 5;
          inner = 5;
          left = 5;
          outer = 5;
          right = 5;
          top = 5;
          smartBorders = "on";
          smartGaps = false;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
        };
        "type:touchpad" = {
          tap = "enabled";
        };
      };

      bars = [{ command = "waybar"; }];

      colors = {
        focused = {
          border = "#${colorscheme.dark.bg_1}";
          background = "#${colorscheme.dark.bg_1}";
          text = "#${colorscheme.dark.fg_1}";
          indicator = "#${colorscheme.dark.bg_1}";
          childBorder = "#${colorscheme.dark.bg_1}";
        };

        focusedInactive = {
          border = "#${colorscheme.dark.bg_0}";
          background = "#${colorscheme.dark.bg_0}";
          text = "#${colorscheme.dark.fg_0}";
          indicator = "#${colorscheme.dark.bg_0}";
          childBorder = "#${colorscheme.dark.bg_0}";
        };

        unfocused = {
          border = "#${colorscheme.dark.bg_0}";
          background = "#${colorscheme.dark.bg_0}";
          text = "#${colorscheme.dark.dim_0}";
          indicator = "#${colorscheme.dark.bg_0}";
          childBorder = "#${colorscheme.dark.bg_0}";
        };

        urgent = {
          border = "#${colorscheme.dark.red}";
          background = "#${colorscheme.dark.red}";
          text = "#${colorscheme.dark.fg_1}";
          indicator = "#${colorscheme.dark.red}";
          childBorder = "#${colorscheme.dark.red}";
        };
      };

      menu = "bemenu-run -c -R 10 -W 0.3 -l 15 -H 30 --fn Inter --nb '#${colorscheme.dark.bg_1}f2' --ab '#${colorscheme.dark.bg_1}f2' --tb '#${colorscheme.dark.bg_1}f2' --fb '#${colorscheme.dark.bg_1}f2' --hb '#${colorscheme.dark.bg_2}f2' --tf '#${colorscheme.dark.fg_0}' --hf '#${colorscheme.dark.fg_1}'";

      output = { "*".bg = ''"${wallpaper}" fill''; };

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          inherit (config.wayland.windowManager.sway.config)
            left down up right menu terminal;
        in
        {
          "${mod}+Shift+Return" = "exec ${terminal}";
          "${mod}+Shift+c" = "kill";
          "${mod}+p" = "exec ${menu}";
          "${mod}+Shift+d" = "exec ${terminal} -e ranger";
          "${mod}+Shift+b" = "exec swaylock -i ${wallpaper}";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+Control+Shift+${left}" = "move to output left";
          "${mod}+Control+Shift+${down}" = "move to output down";
          "${mod}+Control+Shift+${up}" = "move to output up";
          "${mod}+Control+Shift+${right}" = "move to output right";

          "${mod}+Control+Shift+Left" = "move to output left";
          "${mod}+Control+Shift+Down" = "move to output down";
          "${mod}+Control+Shift+Up" = "move to output up";
          "${mod}+Control+Shift+Right" = "move to output right";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+Shift+f" = "fullscreen toggle";
          "${mod}+Shift+s" = "layout stacking";
          "${mod}+Shift+t" = "layout tabbed";
          "${mod}+t" = "layout toggle split";
          "${mod}+a" = "focus parent";
          "${mod}+s" = "focus child";

          "${mod}+r" = "reload";
          "${mod}+Shift+r" = "restart";
        };
    };

    extraConfig = ''
      default_border none
      default_floating_border none
    '';
  };
}