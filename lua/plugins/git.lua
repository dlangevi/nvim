local function getlink()
  local gitlinker = require('gitlinker')
  gitlinker.link({
    action = require("gitlinker.actions").system,
    lstart = vim.api.nvim_buf_get_mark(0, '<')[1],
    lend = vim.api.nvim_buf_get_mark(0, '>')[1]
  })
end

local wk = require('which-key')
wk.add({
  { "<leader>l",  group = "gitlinker" },
  { "<leader>ly", getlink,            desc = "Open in browser" },
  { "<leader>ly", getlink,            desc = "Open in browser", mode = "v" }
})

return {
  'tpope/vim-fugitive',
  'tommcdo/vim-fugitive-blame-ext',
  {
    'linrongbin16/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    opts = {
      mapping = false,
    }
  }
}
