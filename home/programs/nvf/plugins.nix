{pkgs, ...}: {
  programs.nvf.settings.vim.lazy.plugins = {
    "leetcode.nvim" = {
      package = pkgs.vimPlugins.leetcode-nvim;
      setupModule = "leetcode";
      setupOpts = {};
      after = ''
        -- custom lua code to run after plugin is loaded
        print('aerial loaded')
      '';
    };
  };
  programs.nvf.settings.vim.extraPlugins = {
    zen-mode-nvim = {
      package = pkgs.vimPlugins.zen-mode-nvim;
    };
  };
}
