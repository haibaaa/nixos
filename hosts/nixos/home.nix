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

    # personal
    ../../home/programs/yazi

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hyprlock
    ../../home/system/hyprpanel
    ../../home/system/hyprpaper
    ../../home/system/wofi
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie
    ../../home/system/hypridle
    ../../home/system/clipman

    # hyprscratch input
    ../../home/system/hyprscratch
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # staged for deletion
      # bitwarden # Password manager
      # ncspot

      qpdf
      geoclue2

      zed-editor
      helix
      # because thunar is ass
      yazi

      qutebrowser
      # firefox
      presenterm #presentations
      glow #md reader

      # Apps
      github-cli # Github cli
      vlc # Video player
      blanket # White-noise app
      obsidian # Note taking app
      planify # Todolists
      gnome-calendar # Calendar
      textpieces # Manipulate texts
      curtail # Compress images
      resources # Ressource monitor
      gnome-clocks # Clocks app
      gnome-text-editor # Basic graphic text editor
      mpv # Video player

      # Privacy
      session-desktop # Session app, private messages

      # Dev
      go
      rustup
      uv
      jdk25
      bun
      nodejs
      openssl
      prisma-engines
      python3
      jq
      just
      pnpm
      air
      duckdb

      # Utils
      zip
      unzip
      optipng
      jpegoptim
      pfetch
      btop
      fastfetch

      # Just cool
      obs-studio
      peaclock
      cbonsai
      pipes
      gnumake
      cmatrix

      # Backup
      vscode
    ];

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = {source = ./profile_picture.png;};

    # Don't touch this
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
