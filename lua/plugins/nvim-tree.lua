return
-- filebrowsing
{
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ft = 'alpha',
    version = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      local nvimtree = require('nvim-tree')
      local api = require('nvim-tree.api')

      nvimtree.setup({
          view = {
              side = "right",
              preserve_window_proportions = true,
          },
          actions = {
              open_file = {
                  window_picker = {
                      chars = "ASDFGHJKL"
                  },
              },
          },
      })

      require('keymapper').register({
          t = {
              name = "nvim-tree",
              d = {
                  api.tree.toggle, "Toggle NvimTree"
              },
          }
      }, { prefix = "<leader>" })
    end,
}
