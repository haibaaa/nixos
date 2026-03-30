{pkgs, ...}: {
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
    };

    gh.enable = true;

    btop.enable = true;
    fastfetch.enable = true;
    jq.enable = true;
    aria2.enable = true;
  };
}
