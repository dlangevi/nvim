local keymapper = require('keymapper')
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymapper.register({
  d = {
    name = "diagnostics",
    -- TODO this one does not work right now
    e = { vim.diagnostic.open_float, "Open floating diagnostics" },
    q = { vim.diagnostic.setloclist, "Open fixlist diagnostics" },
    p = { vim.diagnostic.goto_prev, "Go to next diagnostic" },
    n = { vim.diagnostic.goto_next, "Go to previous diagnostic" }
  }
}, { prefix = "<leader>" })


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(arg)
  return function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    keymapper.register({
      g = {
        name = "Go to",
        D = { vim.lsp.buf.declaration, "Declaration" },
        d = { vim.lsp.buf.definition, "Definition" },
        i = { vim.lsp.buf.implementation, "Implementation" },
        r = { vim.lsp.buf.references, "References" }
      },
      K = { vim.lsp.buf.hover, "lsp Hover" },
    }, { buffer = bufnr })

    keymapper.register({
      ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
    }, { mode = "i", buffer = bufnr })

    -- Might want to put these all in a l = { 'lsp' } level?
    keymapper.register({
      w = {
        name = "workspace",
        a = { vim.lsp.buf.add_workspace_folder, "Add workspace" },
        r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace" },
        l = { function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspaces" },
      },
      r = { vim.lsp.buf.rename, "Rename variable" },
      D = { vim.lsp.buf.type_definition, "Show type definitions" },
      -- TODO figure out what this is for
      ["ca"] = { vim.lsp.buf.code_action, "Code action" },
    }, { prefix = "<leader>", buffer = bufnr })


    keymapper.register({
      ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
      f = { function()
        if arg.customFormatter then
          arg.customFormatter()
        else
          vim.lsp.buf.format { async = true }
        end
      end, "Format buffer" }
    }, { prefix = "<leader>", buffer = bufnr })
  end
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

return {
  "williamboman/mason.nvim",
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup {
      on_attach = on_attach({}),
      flags = lsp_flags,
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    }
    lspconfig.omnisharp.setup {
      -- cmd = { "dotnet", "C:/Users/David.Langevin/AppLocal/share/nvim/mason/packages/omnisharp/OmniSharp.dll" },
      cmd = {"C:/Users/David.Langevin/scoop/apps/dotnet-sdk-lts/current/dotnet", "C:/Users/David.Langevin/AppData/Local/nvim-data/mason/packages/omnisharp/libexec/OmniSharp.dll" },
      on_attach = on_attach({}),
      enable_editorconfig_support = true,
      enable_ms_build_load_projects_on_demand = false,
      enable_roslyn_analyzers = false,
      organize_imports_on_format = false,
      enable_import_completion = false,
      sdk_include_prereleases = true,
      analyze_open_documents_only = false
    }
  end
}
