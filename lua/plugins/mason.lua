return {
  "williamboman/mason.nvim",
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    local lspconfig = require("lspconfig")
    require("mason").setup()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
    require("mason-lspconfig").setup({
      automatic_installation = false,
      handlers = {
        -- handles jsonls rust_analyzer gopls
        function(server_name) -- default handler
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,

        lua_ls = function()
          lspconfig.lua_ls.setup {
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
        end,

        volar = function()
          lspconfig.volar.setup {
            filetypes = {
              'typescript',
              'javascript',
              'javascriptreact',
              'typescriptreact',
              'vue',
              'html',
              'json'
            },
          }
        end,

        eslint = function()
          lspconfig.eslint.setup {
            filetypes = {
              'typescript',
              'javascript',
              'vue',
            },
            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,
          }
        end,
      }
    })
  end
}
