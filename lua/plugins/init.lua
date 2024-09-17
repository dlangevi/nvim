return {
  { -- Helpful hints for keybinds
    "folke/which-key.nvim",
    lazy = true,
    init = function()
      local wk = require('which-key');
      -- Keybindings unrelated to any other plugin
      wk.add({
        -- Preview all key bindings
        { "<leader>?",         wk.show,             desc = "Preview all bindings" },

        -- Old habit I have picked up from a previous leader key. switches to
        -- whatever buffer was previously in the current pane
        { "--",                ":edit<Space>#<cr>", desc = "Edit previous file" },

        -- Some way of doing this automatically would be nice when in nvim lua files
        -- maybe some comment at the top of a file would indicate its safe to reload
        { "<leader><leader>s", "<cmd>source %<cr>", desc = "Source current file" },

        -- Easy quit (todo need an alterante macro binding
        -- Maybe want to make this <leader>q ?
        { "q",                 ":q<CR>",            desc = "Quit" },
      })
    end
  },

  -- full signature help, docs and completion for the nvim lua API
  {
    "folke/neodev.nvim",
    opts = {
      library = {
        plugins = {
          "nvim-dap-ui",
          "nvim-dap"
        },
        types = true
      },
    },
  },
  { 'nvim-lua/plenary.nvim',    lazy = true },

  {
    'fei6409/log-highlight.nvim',
    config = function()
      require('log-highlight').setup {}
    end,
  },

  {
    'EtiamNullam/deferred-clipboard.nvim',
    opts = {
      lazy = true,
      -- fallback = 'unnamedplus',
    },
  },

  -- Visual enhancements
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
      },
      scope = {
        enabled = false,
      },
    }
  },
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
    opts = { '*' },
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
  { 'numToStr/Comment.nvim',    config = true },
  { "kylechui/nvim-surround",   config = true },
  { 'ethanholz/nvim-lastplace', config = true },

  -- enable tmux navigation
  {
    'mrjones2014/smart-splits.nvim',
    init = function()
      local navigator = require('smart-splits');
      local which = require('which-key');
      -- Keybindings
      which.add({
        -- Tmux Navigator
        { "<c-h>",   navigator.move_cursor_left,  desc = 'Navigate Left' },
        { "<c-l>",   navigator.move_cursor_right, desc = 'Navigate Right' },
        { "<c-k>",   navigator.move_cursor_up,    desc = 'Navigate Up' },
        { "<c-j>",   navigator.move_cursor_down,  desc = 'Navigate Down' },
        { "<c-a-h>", navigator.resize_left,       desc = 'Resize Left' },
        { "<c-a-l>", navigator.resize_right,      desc = 'Resize Right' },
        { "<c-a-k>", navigator.resize_up,         desc = 'Resize Up' },
        { "<c-a-j>", navigator.resize_down,       desc = 'Resize Down' },
      })
    end

  },

}
