{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Mostly user-specific configuration
    ./variables.nix

    # Programs
    ../../home/programs/tmux
    ../../home/programs/kitty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/git/signing.nix
    ../../home/programs/spicetify
    ../../home/programs/thunar
    ../../home/programs/lazygit
    ../../home/programs/zen
    ../../home/programs/discord
    ../../home/programs/tailscale
    ../../home/programs/qutebrowser
    ../../home/programs/antigravity
    ../../home/programs/cli
    ../../home/programs/zed-editor
    ../../home/programs/obs-studio
    ../../home/programs/mpv
    ../../home/programs/dev
    ../../home/programs/gui
    ../../home/programs/rice
    ../../home/programs/utils

    # personal
    ../../home/programs/yazi

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hyprlock
    # ../../home/system/swaylock
    # ../../home/system/hyprpanel
    ../../home/system/hyprpaper
    ../../home/system/wofi
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie
    ../../home/system/hypridle
    ../../home/system/clipman
    ../../home/system/noctalia

    # hyprscratch input
    ../../home/system/hyprscratch
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # staged for deletion
      # bitwarden # Password manager
      # nix-search-tv
      # firefox
      # ncspot
    ];

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = {
      source = ./profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
