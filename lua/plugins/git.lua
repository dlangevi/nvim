local function getlink()
  local gitlinker = require('gitlinker')
  gitlinker.link({
    action = require("gitlinker.actions").system,
    lstart = vim.api.nvim_buf_get_mark(0, '<')[1],
    lend = vim.api.nvim_buf_get_mark(0, '>')[1]
  })
end
vim.mapname("<leader>l", 'gitlinker')

return {
  'linrongbin16/gitlinker.nvim',
  requires = 'nvim-lua/plenary.nvim',
  keys = {
    { "<leader>ly", getlink, desc = "Open in browser" },
    {
      "<leader>ly",
      getlink,
      desc = "Open in browser",
      mode = "v"
    }
  },
  opts = {
    mapping = false,
  }
}
