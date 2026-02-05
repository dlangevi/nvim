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
  local capabilities = M.get_capabilities()

  -- Lua
  vim.lsp.enable('luals')
  vim.lsp.config('luals', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
      })
    end,
    settings = {
      Lua = {},
    },
})

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
  vim.lsp.config('omnisharp', {
    capabilities = capabilities,
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    -- On NixOS, omnisharp will be in PATH, so just use the command directly
    cmd = { "OmniSharp" },
    enable_editorconfig_support = true,
    enable_ms_build_load_projects_on_demand = false,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = false,
    enable_import_completion = true,
    sdk_include_prereleases = true,
    analyze_open_documents_only = true,
  })

  -- Add other simple servers (jsonls, rust_analyzer, gopls, etc.)
  -- These will work automatically if installed via NixOS
  local simple_servers = { 'jsonls', 'rust_analyzer', 'gopls', 'ts_ls', 'clangd', 'omnisharp' }
  for _, server in ipairs(simple_servers) do
    vim.lsp.enable(server)
    vim.lsp.config[server] = {
      capabilities = capabilities,
    }
  end
end

return M
