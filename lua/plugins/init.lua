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

        -- AI CLIs
        { "<leader>c",         group = "AI" },
        { "<leader>cg",        "<cmd>GeminiHere<cr>",   desc = "Gemini CLI" },
        { "<leader>cc",        "<cmd>CopilotHere<cr>",  desc = "Copilot CLI" },

        -- Old habit I have picked up from a previous leader key. switches to
        -- whatever buffer was previously in the current pane
        { "--",                ":edit<Space>#<cr>", desc = "Edit previous file" },

        -- Some way of doing this automatically would be nice when in nvim lua files
        -- maybe some comment at the top of a file would indicate its safe to reload
        { "<leader><leader>s", "<cmd>source %<cr>", desc = "Source current file" },
        { "<leader><leader>r", "<cmd>source $MYVIMRC<cr>", desc = "Reload nvim config" },

        -- Easy quit (todo need an alterante macro binding
        -- Maybe want to make this <leader>q ?
        { "q",                 ":q<CR>",            desc = "Quit" },

        { "<C-q>",             "q",                 desc = "Start/Stop Macro Recording" },

        -- Insert mode: jk and kj to escape to normal mode
        { "jk",                "<Esc>",             desc = "Exit insert mode", mode = "i" },
        { "kj",                "<Esc>",             desc = "Exit insert mode", mode = "i" },

        -- Terminal mode: jk and kj to escape to normal mode
        { "jk",                [[<C-\><C-n>]],      desc = "Exit terminal mode", mode = "t" },
        { "kj",                [[<C-\><C-n>]],      desc = "Exit terminal mode", mode = "t" },
      })
    end
  },

  { "github/copilot.vim" },

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
  { 'nvim-lua/plenary.nvim', lazy = true },

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
    -- -@module "ibl"
    -- -@type ibl.config
    -- opts = {},
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

  {
    'neovim/nvim-lspconfig',
    init = function()
      require('lsp.init').setup()
    end,
  },

  -- Repl
  {
    'Vigemus/iron.nvim',
    config = function()
      local iron = require('iron.core');
      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" }
            },
            python = {
              command = { "python3" }, -- or { "ipython", "--no-autoindent" }
              format = require("iron.fts.common").bracketed_paste_python
            }
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').right(80),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = "<space>rc",
          visual_send = "<space>rc",
          send_file = "<space>rf",
          send_line = "<space>rl",
          send_paragraph = "<space>rp",
          send_until_cursor = "<space>ru",
          send_mark = "<space>rm",
          mark_motion = "<space>rc",
          mark_visual = "<space>rc",
          remove_mark = "<space>rd",
          cr = "<space>r<cr>",
          interrupt = "<space>r<space>",
          exit = "<space>rq",
          clear = "<space>rl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    end
  }
}
