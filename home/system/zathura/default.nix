# Zathura is a PDF viewer
{
  programs.zathura = {
    enable = true;

    options = {
      guioptions = "v";
      adjust-open = "width";
      statusbar-basename = true;
      render-loading = false;
      scroll-step = 120;
      "selection-clipboard" = "clipboard"; # Add this line to enable clipboard copy
    };
  };
}
