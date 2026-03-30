{pkgs, ...}: {
  home.packages = with pkgs; [
    # System & Environment utils
    nix-ld
    geoclue2
    stow
    hashcat

    # File and document manipulators
    qpdf
    presenterm
    glow
    zip
    unzip
    optipng
    jpegoptim
  ];
}
