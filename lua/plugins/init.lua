local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

return {
  -- Visual enhancements
  "lukas-reineke/indent-blankline.nvim",
  {
    -- Our main colorscheme
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme sonokai]]
    end,
  },
  {
    "folke/neodev.nvim",
    opts = {}
  },
  {
    -- Adds #239299 Colors!
    'norcalli/nvim-colorizer.lua',
    config = true,
  },
  -- {
  --   'rmagatti/auto-session',
  --   config = function()
  --     require("auto-session").setup {
  --       log_level = "error",
  --       auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  --
  --     }
  --   end
  -- },
  {
    'linrongbin16/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local keymapper = require('keymapper')
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
      keymapper.register({
        l = {
          y = { getlink, "Open in browser?" }
        }
      }, { mode = "n", prefix = "<leader>" })
      keymapper.register({
        l = {
          y = { getlink, "Open in browser?" }
        }
      }, { mode = "v", prefix = "<leader>" })
    end
  },
  {
    'anuvyklack/help-vsplit.nvim',
    config = function()
      require('help-vsplit').setup({
        always = true,
        side = 'left',
      })
    end
  },

  -- startup screen
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require 'alpha'.setup(require 'alpha.themes.startify'.config)
    end
  },

  -- added editing functionality
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- for stability
    config = function()
      require("nvim-surround").setup({})
    end
  },

  -- enable tmux navigation
  { 'mrjones2014/smart-splits.nvim' },

  -- Helpful hints for keybinds
  {
    "folke/which-key.nvim",
    lazy = false,
    priority = 999, -- load this first since many others depend on it for keybindings
    config = function()
      require("which-key").setup {
        plugins = {
          spelling = {
            enabled = true
          }
        }
      }
    end
  },
}
