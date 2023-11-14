return
-- filebrowsing
{
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = 'nightly', -- optional, updated every week. (see issue #1193)
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
    require('which-key').register({
      n = {
        name = "nvim-tree",
        d = {
          api.tree.toggle, "Toggle NvimTree"
        },
        r = {
          function()
            local cwd = vim.loop.cwd();
            print(cwd)
            api.tree.change_root(cwd);
          end, "Restore root"
        }
      }
    }, { prefix = "<leader>" })
  end,
}
