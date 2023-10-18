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
    -- Adds #239299 Colors!
    'norcalli/nvim-colorizer.lua',
    config = true,
  },
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   config = function()
  --     require("chatgpt").setup({
  --       -- optional configuration
  --     })
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   }
  --
  -- },

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
      require("nvim-surround").setup({
      })
    end
  },
  -- { "L3MON4D3/LuaSnip", version = "v<CurrentMajor>.*" },

  -- enable tmux navigation
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
    end
  },


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
