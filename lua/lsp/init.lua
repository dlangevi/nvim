local M = {}

function M.setup()
  local diagnostics = require('lsp.diagnostics')
  local keymaps = require('lsp.keymaps')
  local servers = require('lsp.servers')

  -- Setup diagnostics keymaps
  diagnostics.setup_keymaps()

  -- Setup LSP buffer keymaps on attach
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      keymaps.setup_buffer_keymaps(ev, client)
    end
  })

  servers.setup_servers()
end

return M
