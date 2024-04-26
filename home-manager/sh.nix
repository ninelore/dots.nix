{ pkgs
, config
, ...
}:
let
  shellAliases = {
    "db" = "distrobox";
    "untar" = "tar -xavf";
    "v" = "nvim";
    "ll" = "ls -a";
    "l" = "ls";
    "l." = "ls -d .*";
    "sv" = "sudo nvim";
    "r" = "ranger";
    "sr" = "sudo ranger";
    "c" = "clear";
    "crypo" = "sudo cryptsetup open";
    "crypc" = "sudo cryptsetup close";
    "py" = "python3";
    "grep" = "grep --color=auto";

    "nxgc" = "nix-collect-garbage --delete-older-than 7d";

    ":q" = "exit";
    "q" = "exit";
  };
in
{
  programs = {
    bash = {
      inherit shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };

    nushell = {
      inherit shellAliases;
      enable = true;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "\"  \"";
        PROMPT_INDICATOR_VI_NORMAL = "\"  \"";
        #PROMPT_COMMAND = ''{|| create_left_prompt }'';
        PROMPT_COMMAND_RIGHT = ''""'';
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
      };
      extraEnv = ''
        def create_left_prompt [] {
          let home =  $nu.home-path
          let dir = ([
              ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
              ($env.PWD | str substring ($home | str length)..)
          ] | str join)
          let path_color = (if (is-admin) { red_bold } else { green_bold })
          let separator_color = (if (is-admin) { light_red_bold } else { light_green_bold })
          let path_segment = $"($path_color)($dir)"
          $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
        }
      '';
      extraConfig =
        let
          theme = "molokai";

          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";
            shell_integration = true;

            ls.clickable_links = true;
            rm.always_trash = true;

            table = {
              index_mode = "always"; # always never auto
              header_on_separator = false;
            };

            cursor_shape = {
              vi_insert = "line";
              vi_normal = "block";
            };

            menus = [
              {
                name = "completion_menu";
                only_buffer_difference = false;
                marker = "  ";
                type = {
                  layout = "columnar"; # list, description
                  columns = 4;
                  col_padding = 2;
                };
                style = {
                  text = "magenta";
                  selected_text = "blue_reverse";
                  description_text = "yellow";
                };
              }
            ];
          };
          completions =
            let
              completion = name: ''
                source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
              '';
            in
            names:
            builtins.foldl'
              (prev: str: "${prev}\n${str}") ""
              (map (name: completion name) names);
        in
        ''
          use ${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/${theme}.nu;
          $env.config = ${conf};
          $env.config.color_config = (${theme});
          ${completions ["cargo" "git" "nix" "npm"]}
        '';
    };
  };
}
