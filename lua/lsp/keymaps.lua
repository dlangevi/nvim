local M = {}

function M.setup_buffer_keymaps(ev, client)
  local wk = require('which-key')
  
  local function formatBuffer()
    -- volar's format doesnt respect eslint rules
    if client ~= nil and client.name == "volar" then
      vim.cmd "EslintFixAll"
    else
      vim.lsp.buf.format({ async = true })
    end
  end

  wk.add({
    {
      buffer = ev.buf,
      { "K",             vim.lsp.buf.hover,           desc = "lsp Hover" },

      { "g",             group = "Go to" },
      { "gD",            vim.lsp.buf.declaration,     desc = "Declaration" },
      { "gT",            vim.lsp.buf.type_definition, desc = "Show type definitions" },
      { "gd",            vim.lsp.buf.definition,      desc = "Definition" },
      { "gi",            vim.lsp.buf.implementation,  desc = "Implementation" },
      { "gr",            vim.lsp.buf.references,      desc = "References" },

      { "<leader>r",     vim.lsp.buf.rename,          desc = "Rename variable" },
      { "<leader><c-k>", vim.lsp.buf.signature_help,  desc = "lsp Signature help" },
      { "<leader>f",     formatBuffer,                desc = "Format buffer" },

      {
        mode = "i",
        { "c-k", vim.lsp.buf.signature_help, desc = "lsp Signature help" },
      },

      {
        mode = { "n", "v" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
      }
    }
  })
end

return M
