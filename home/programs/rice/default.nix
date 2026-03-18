{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Fonts
    fira-code
    material-design-icons

    # Terminal Fun
    peaclock
    cbonsai
    pipes
    cmatrix
    pfetch
  ];
}
