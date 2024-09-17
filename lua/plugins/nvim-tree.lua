return
-- filebrowsing
{
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = "<leader>n",
  opts = {
    view = {
      side = "right",
      preserve_window_proportions = true,
      width = 50,
    },
    actions = {
      open_file = {
        resize_window = false,
        window_picker = {
          chars = "ASDFGHJKL"
        },
      },
    },
  },
  init = function()
    local api = require('nvim-tree.api')
    local wk = require('which-key')
    wk.add(
      {
        { "<leader>n",  group = "nvim-tree" },
        { "<leader>nd", api.tree.toggle,    desc = "Toggle NvimTree" },
        {
          "<leader>nr",
          function()
            local cwd = vim.loop.cwd();
            print(cwd)
            api.tree.change_root(cwd);
          end,
          desc = "Restore root"
        },
      })
  end,
}
