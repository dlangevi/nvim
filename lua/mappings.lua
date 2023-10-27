-- wont work on first load
--local navigator = require('Navigator');
local navigator = require('smart-splits');
local which = require('which-key');
-- Keybindings
require('keymapper').register({
  -- Tmux Navigator
  ["<c-h>"] = { navigator.move_cursor_left, 'Navigate Left' },
  ["<c-l>"] = { navigator.move_cursor_right, 'Navigate Right' },
  ["<c-k>"] = { navigator.move_cursor_up, 'Navigate Up' },
  ["<c-j>"] = { navigator.move_cursor_down, 'Navigate Down' },
  ["<c-s-h>"] = { navigator.resize_left, 'Navigate Left' },
  ["<c-s-l>"] = { navigator.resize_right, 'Navigate Right' },
  ["<c-s-k>"] = { navigator.resize_up, 'Navigate Up' },
  ["<c-s-j>"] = { navigator.resize_down, 'Navigate Down' },
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

-- require('keymapper').register({
--   { prefix = "<leader>" }
-- })
