return {
  'nvim-lualine/lualine.nvim',
  -- eependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local horizon = require('lualine.themes.horizon')

    local colors = {
      -- Taken from horizon theme just used here for reference
      black        = '#1c1e26',
      white        = '#6C6F93',
      red          = '#F43E5C',
      green        = '#09F7A0',
      blue         = '#25B2BC',
      yellow       = '#F09383',
      gray         = '#E95678',
      darkgray     = '#1A1C23',
      lightgray    = '#2E303E',
      inactivegray = '#1C1E26',
      myinactive   = '#aaaaaa'
    }
    horizon.inactive.c.fg = colors.myinactive

    require('lualine').setup({
      options = {
        theme = horizon,
      },
      sections = {
        lualine_c = { {
          'filename',
          path = 1,
        } },
      },
      winbar = {
        lualine_a = { 'filetype' },
        lualine_b = {},
        lualine_c = { 'filename' },
      },
      inactive_winbar = {
        lualine_a = { 'filetype' },
        lualine_b = {},
        lualine_c = { 'filename' },
      }
    })
  end,
}
