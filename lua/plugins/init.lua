return {
  { -- Helpful hints for keybinds
    "folke/which-key.nvim",
    lazy = false,
    priority = 999, -- load this first since many others depend on it for keybindings
    config = function()
      local which = require('which-key');
      -- Keybindings
      which.register({
        -- Preview all key bindings
        ['<leader>?'] = { which.show, "Preview all bindings" },
        ['<leader>x'] = { "<cmd>RunCode<cr>", "Run Code" },
        -- Old habit I have picked up from a previous leader key. switches to
        -- whatever buffer was previously in the current pane
        ['--'] = { ':edit<Space>#<cr>', "Edit previous file" },

        -- Some way of doing this automatically would be nice when in nvim lua files
        -- maybe some comment at the top of a file would indicate its safe to reload
        ['<leader><leader>s'] = { '<cmd>source %<cr>', "Source current file" },

        -- Easy quit (todo need an alterante macro binding
        q = { ':q<CR>', "Quit" },

      })
    end
  },

  -- full signature help, docs and completion for the nvim lua API
  "folke/neodev.nvim",

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
    config = function()
      require('colorizer').setup({
        '*',
      })
    end,
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
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      local navigator = require('smart-splits');
      local which = require('which-key');
      -- Keybindings
      which.register({
        -- Tmux Navigator
        ["<c-h>"] = { navigator.move_cursor_left, 'Navigate Left' },
        ["<c-l>"] = { navigator.move_cursor_right, 'Navigate Right' },
        ["<c-k>"] = { navigator.move_cursor_up, 'Navigate Up' },
        ["<c-j>"] = { navigator.move_cursor_down, 'Navigate Down' },
        ["<c-a-h>"] = { navigator.resize_left, 'Resize Left' },
        ["<c-a-l>"] = { navigator.resize_right, 'Resize Right' },
        ["<c-a-k>"] = { navigator.resize_up, 'Resize Up' },
        ["<c-a-j>"] = { navigator.resize_down, 'Resize Down' },
      })
    end

  },

}
