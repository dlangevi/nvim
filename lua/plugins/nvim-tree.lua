base_settings = {
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
}

return
-- filebrowsing
{
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = "<leader>n",
  opts = base_settings,
  init = function()
    local tree = require('nvim-tree')
    local api = require('nvim-tree.api')
    local wk = require('which-key')

    showall = function()
      base_settings["git"] = {
        ignore = false
      }
      tree.setup(base_settings)
    end

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
        { "<leader>na", showall, desc = "Toggle NvimTree hidden files" },
      })
  end,
}
