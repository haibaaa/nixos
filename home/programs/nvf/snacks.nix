{
  programs.nvf.settings.vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      image = {
        enabled = true;
        setupOpts.doc.inline = false;
      };
      quickfile.enabled = true;
      statuscolumn.enabled = true;

      zen = {
        enabled = true;
        show = {
          statusline = false;
          tabline = false;
        };
        relativenumber = false;
        number = false;
        toggles = {
          dim = true;
        };
      };
      bufdelete.enabled = true;
      dim.enabled = true;
      gitsigns.enabled = true;
    };
  };
}
