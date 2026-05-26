return {
  "williamboman/mason.nvim",
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'Hoffs/omnisharp-extended-lsp.nvim',
  },
  config = function()
    local lspconfig = require("lspconfig")
    require("mason").setup()
    local function getInstallPath(package)
      local registry = require("mason-registry")
      return registry.get_package(package):get_install_path()
    end

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

        omnisharp = function()
          local ok, omnisharp_extended = pcall(require, 'omnisharp_extended')
          lspconfig.omnisharp.setup {
            capabilities = capabilities,
            handlers = ok and {
              ["textDocument/definition"] = omnisharp_extended.handler,
            } or nil,
            cmd = { "dotnet", getInstallPath("omnisharp") .. "/libexec/OmniSharp.dll",
              "--languageserver" },
            enable_editorconfig_support = true,
            enable_ms_build_load_projects_on_demand = false,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = false,
            enable_import_completion = true,
            sdk_include_prereleases = true,
            analyze_open_documents_only = true,
          }
        end
      }
    })
  end
}
