return {
  'linrongbin16/gitlinker.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    local wk = require('which-key')
    local gitlinker = require('gitlinker')

    local options = {
      mapping = false,
    }
    local function getlink()
      gitlinker.link({
        action = require("gitlinker.actions").system,
        lstart = vim.api.nvim_buf_get_mark(0, '<')[1],
        lend = vim.api.nvim_buf_get_mark(0, '>')[1]
      })
    end

    gitlinker.setup(options)
    wk.register({
      l = {
        y = { getlink, "Open in browser?" }
      }
    }, { mode = "n", prefix = "<leader>" })
    wk.register({
      l = {
        y = { getlink, "Open in browser?" }
      }
    }, { mode = "v", prefix = "<leader>" })
  end
}
