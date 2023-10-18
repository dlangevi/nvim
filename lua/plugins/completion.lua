return {
    { "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
          local cmp = require "cmp"
          if not cmp then
            return
          end

          cmp.setup { mapping = {
              ["<C-n>"] = cmp.mapping.select_next_item {
                  behavior = cmp.SelectBehavior.Insert
              },
              ["<C-p>"] = cmp.mapping.select_prev_item {
                  behavior = cmp.SelectBehavior.Insert
              },
              ["<C-d>"] = cmp.mapping.scroll_docs( -4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<c-y>"] = cmp.mapping(
                  cmp.mapping.confirm {
                      behavior = cmp.ConfirmBehavior.Insert,
                      select = true,
                  },
                  { "i", "c" }
              ),
          },
              sources = {
                  { name = "path" },
                  { name = "nvim_lsp" },
                  { name = "buffer",  keyword_length = 5 },
                  { name = "luasnip" },
                  { name = "nvim_lua" },
              },

              snippet = {
                  expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                  end,
              },

              experimental = {
                  native_menu = false,
                  ghost_text = true,
              },

              formatting = {
                  format = require("lspkind").cmp_format {
                      with_text = true,
                      menu = {
                          buffer = "[buf]",
                          nvim_lsp = "[LSP]",
                          nvim_lua = "[api]",
                          path = "[path]",
                          luasnip = "[snip]",
                      },
                  },
              },
          }
        end
    }
}
