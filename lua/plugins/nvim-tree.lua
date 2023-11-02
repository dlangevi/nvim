return
-- filebrowsing
{
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = 'nightly',   -- optional, updated every week. (see issue #1193)
  config = function()
    local nvimtree = require('nvim-tree')
    local api = require('nvim-tree.api')
    nvimtree.setup({
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
    })

    require('keymapper').register({
      d = {
        name = "nvim-tree",
        d = {
          api.tree.toggle, "Toggle NvimTree"
        },
      }
    }, { prefix = "<leader>" })
  end,
  keys = "<leader>d",
}
