{pkgs, ...}: {
  programs.nvf.settings.vim.extraPlugins = {
    zen-mode-nvim = {
      package = pkgs.vimPlugins.zen-mode-nvim;
    };
  };
}
