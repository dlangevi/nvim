local M = {}

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }
  return capabilities
end

function M.setup_servers()
  local lspconfig = vim.lsp.config
  local capabilities = M.get_capabilities()

  -- Lua
  vim.lsp.enable('luals')
  vim.lsp.config.luals = {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
    },
  }

  -- Volar (Vue/TypeScript)
  -- lspconfig.volar.setup {
  --   capabilities = capabilities,
  --   filetypes = {
  --     'typescript',
  --     'javascript',
  --     'javascriptreact',
  --     'typescriptreact',
  --     'vue',
  --     'html',
  --     'json'
  --   },
  -- }
  --
  -- -- ESLint
  -- lspconfig.eslint.setup {
  --   capabilities = capabilities,
  --   filetypes = {
  --     'typescript',
  --     'javascript',
  --     'vue',
  --   },
  --   on_attach = function(_, bufnr)
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       buffer = bufnr,
  --       command = "EslintFixAll",
  --     })
  --   end,
  -- }

  -- OmniSharp (C#)
  -- lspconfig.omnisharp.setup {
  --   capabilities = capabilities,
  --   handlers = {
  --     ["textDocument/definition"] = require('omnisharp_extended').handler,
  --   },
  --   -- On NixOS, omnisharp will be in PATH, so just use the command directly
  --   cmd = { "OmniSharp" },
  --   enable_editorconfig_support = true,
  --   enable_ms_build_load_projects_on_demand = false,
  --   enable_roslyn_analyzers = true,
  --   organize_imports_on_format = false,
  --   enable_import_completion = true,
  --   sdk_include_prereleases = true,
  --   analyze_open_documents_only = true,
  -- }

  -- Add other simple servers (jsonls, rust_analyzer, gopls, etc.)
  -- These will work automatically if installed via NixOS
  local simple_servers = { 'jsonls', 'rust_analyzer', 'gopls', 'ts_ls', 'clangd' }
  for _, server in ipairs(simple_servers) do
    vim.lsp.enable(server)
    vim.lsp.config[server] = {
      capabilities = capabilities,
    }
  end
end

return M
