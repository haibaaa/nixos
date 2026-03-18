{
  inputs,
  pkgs,
  ...
}: {
  # this tells home manager to install the package from the flake input
  home.packages = [
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-no-fhs
  ];
}
