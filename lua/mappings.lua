-- wont work on first load
local navigator = require('Navigator');
local which = require('which-key');
-- Keybindings
require('keymapper').register({
  -- Tmux Navigator
  ["<c-h>"] = { navigator.left, 'Navigate Left' },
  ["<c-l>"] = { navigator.right, 'Navigate Right' },
  ["<c-k>"] = { navigator.up, 'Navigate Up' },
  ["<c-j>"] = { navigator.down, 'Navigate Down' },
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
