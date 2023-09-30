{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.hyprland.homeManagerModules.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  home = {
    username = "haam";
    homeDirectory = "/home/haam";
    stateVersion = "23.05";
  };
  # Nicely reload system units when changing configs

  # Enable git
  programs.git.enable = true;
  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = false;
  };
  # Enable eww
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./configs/eww;
  };
  # Enable Wezterm
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./configs/wezterm/wezterm;
  };
  # Enable FireFox
  programs.firefox = {
    enable = true;
    profiles = {
      haam = {
        name = "haam";
        isDefault = true;
        search = {
          default = "google";
          engines = {
            "Nix Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "Google".metaData.alias =
              "@g"; # builtin engines only support specifying one additional alias
          };
          order = [ "DuckDuckGo" "Google" ];
        };
        userChrome = builtins.readFile ./configs/firefox/userChrome;
        userContent = builtins.readFile ./configs/firefox/userContent;
      };
    };
  };

  # Enable
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
  # Enable Dunst
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        geometry = "300x60-15+46";
        indicate_hidden = "yes";
        shrink = "yes";
        transparency = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 3;
        frame_color = "#000000";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        font = "Museo Sans 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b> %b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = "true";
        hide_duplicate_count = "false";
        show_indicators = "yes";
        icon_position = "left";
        max_icon_size = 42;
        icon_path =
          "/usr/share/icons/candy-icons/apps/scalable:/usr/share/icons/candy-icons/devices/scalable/";
        sticky_history = "yes";
        history_length = 20;
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";
        always_run_script = "true";
        title = "Dunst";
        class = "Dunst";
        startup_notification = "false";
        verbosity = "mesg";
        corner_radius = 8;
        force_xinerama = "false";
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
      };
      urgency_low = {
        foreground = "#a9b1d6";
        background = "#1a1b26";
        frame_color = "#0db9d7";
        timeout = 10;
        icon = "~/.config/dunst/images/notification.svg";
      };
      urgency_normal = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        frame_color = "#0db9d7";
        timeout = 10;
        icon = "~/.config/dunst/images/notification.svg";
      };
      urgency_critical = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        frame_color = "#0db9d7";
        timeout = 0;
        icon = "~/.config/dunst/images/notification.svg";
      };
    };
  };

  # Enable Btop
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      theme_background = false;
    };
  };
  # XDG Dirc config
  xdg = {
    userDirs = {
      enable = true;
      desktop = "";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public-share";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
      extraConfig = {
        XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
      }

      ;
    };
  };
  # Enable mpv
  programs.mpv = {
    enable = true;
    bindings = {
      "MBTN_RIGHT" = "ignore";
      "MBTN_BACK" = "ignore";
      "MBTN_FORWARD" = "ignore";
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
      "WHEEL_LEFT" = "ignore";
      "WHEEL_RIGHT" = "ignore";
      "BS" = "ignore";
      "q" = "ignore";
      "Q" = "ignore";
      ">" = "ignore";
      "<" = "ignore";
      "z" = "ignore";
      "Z" = "ignore";
      "x" = "ignore";
      "/" = "ignore";
      "*" = "ignore";
      "Alt+0" = "ignore";
      "v" = "ignore";
      "V" = "ignore";
      "S" = "ignore";
      "Ctrl+s" = "ignore";
      "ctrl+c" = "ignore";
      "DEL" = "ignore";
      "PGUP" = "ignore";
      "PGDWN" = "ignore";
      "Alt++" = "ignore";
      "Alt+-" = "ignore";
      "Alt+BS" = "ignore";
      "Alt+left" = "ignore";
      "Alt+right" = "ignore";
      "Alt+up" = "ignore";
      "Alt+down" = "ignore ";
      "Alt+LEFT" = "ignore ";
      "Alt+RIGHT" = "ignore ";
      "Alt+UP" = "ignore ";
      "Alt+DOWN" = "ignore ";
      "Alt+HOME" = "ignore ";
      "Alt+END" = "ignore ";
      "w" = "ignore";
      "W" = "ignore ";
      "e" = "ignore";
      "E" = "ignore";
      "r" = "ignore";
      "R" = "ignore";
      "t" = "ignore";
      "T" = "ignore";
      "u" = "ignore";
      "U" = "ignore";
      "o" = "ignore";
      "O" = "ignore";
      "d" = "ignore";
      "D" = "ignore";
      "LEFT" = " no-osd seek -5 exact";
      "RIGHT" = " no-osd seek 5 exact";
      "SHift+LEFT" = "o-osd seek -60 exact";
      "SHIFT+RIGHT" = "o-osd seek 60 exact";
      "h" = "o-osd seek -5 exact";
      "l" = "o-osd seek 5 exact";
      "L" = "o-osd seek -60 exact";
      "H" = "o-osd seek 60 exact";
      "HOME" = "o-osd seek 0 absolute-percent";
      "0" = "o-osd seek 0 absolute-percent";
      "1" = "o-osd seek 10 absolute-percent+exact";
      "2" = "o-osd seek 20 absolute-percent+exact";
      "3" = "o-osd seek 30 absolute-percent+exact";
      "4" = "o-osd seek 40 absolute-percent+exact";
      "5" = "o-osd seek 50 absolute-percent+exact";
      "6" = "o-osd seek 60 absolute-percent+exact";
      "7" = "o-osd seek 70 absolute-percent+exact";
      "8" = "o-osd seek 80 absolute-percent+exact";
      "9" = "o-osd seek 90 absolute-percent+exact";
      "`" = "no-osd seek 100 absolute-percent+exact";
      "END" = "o-osd seek 100 absolute-percent+exact";
      "UP" = "dd volume 2";
      "DOWN" = "dd volume -2";
      "SHIFT+UP" = "dd volume 10";
      "SHIFT+DOWN" = "dd volume -10";
      "k" = "dd volume 2";
      "j" = "dd volume -2";
      "K" = "dd volume 10";
      "J" = "dd volume -10";
      "m" = "ycle mute";
      "Ctrl+=" = "o-osd add video-zoom 0.1";
      "Ctrl+-" = "o-osd add video-zoom -0.1";
      "{" = "add speed -1";
      "}" = "add speed 1";
      "[" = "add speed -0.25";
      "]" = "add speed 0.25";
      "f" = "ycle fullscreen";
      "F" = "ycle fullscreen";
      "n" = "laylist-next";
      "p" = "laylist-prev";
      "s" = "ycle sub-visibility";
      "i" = "cript-binding stats/display-stats-toggle";
    };
    config = {
      fs = "no";
      keep-open = "yes";
      osc = "no";
      ontop = "no";
    };
  };
  # Enable lf
  programs.lf = {
    enable = true;
    commands = {
      mkdir = " printf \"Directory Name:\" read ans mkdir $ans";
      mkfile = ''printf "File Name: " read ans $EDITOR $ans'';
    };
    settings = {
      hidden = true;
      ignorecase = true;
      ratios = "1:1:2";
      icons = true;
    };
    keybindings = {
      "." = "set hidden!";
      dd = "trash";
      dr = "restore_trash";
      p = "paste";
      x = "cut";
      y = "copy";
      "<enter>" = "open";
      R = "reload";
      mf = "mkfile";
      md = "mkdir";
      C = "clear";
      gD = "cd ~/documents";
      gd = "cd ~/downloads";
      gP = "cd ~/pictures";
      gc = "cd ~/.config";
      gp = "cd ~/projects";
      gv = "cd ~/videos";
      gt = "cd ~/.local/share/Trash/files";
    };
  };
  # Enable ZSH
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
