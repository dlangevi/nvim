return {
  -- { "github/copilot.vim" },

  {
    "folke/sidekick.nvim",
    cmd = "Sidekick",
    keys = {
      {
        "<c-y>",
        function() require("sidekick").nes_jump_or_apply() end,
        desc = "Sidekick Nes Apply",
        mode = { "n" },
      },
      {
        "<c-u>",
        function() require("sidekick.nes").clear() end,
        desc = "Sidekick Nes Clear",
        mode = { "n" },
      },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select({ filter = { names = { "claude", "gemini", "copilot" } } }) end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
        {
          "<leader>at",
          function() require("sidekick.cli").send({ msg = "{this}" }) end,
          mode = { "x", "n" },
          desc = "Send This",
        },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
        {
          "<leader>av",
          function() require("sidekick.cli").send({ msg = "{selection}" }) end,
          mode = { "x" },
          desc = "Send Visual Selection",
        },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
      {
        "<leader>ag",
        function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end,
        desc = "Sidekick Toggle Gemini",
      },
    },
    config = function(_, opts)
      require("sidekick").setup(opts)
      require("which-key").add({
        { "<leader>a", group = "Agents" },

      })
    end,
    opts = {
      nes = {
        enabled = true,
      },
      cli = {
        win = {
          layout = "right",
          split = {
            width = 120,
          },
        },
      },
    },
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim"
  --   },
  --   opts = {
  --     strategies = {
  --       chat = {
  --         adapter = "anthropic",
  --         model = "claude-sonnet-4-20250514"
  --       },
  --     },
  --     -- NOTE: The log_level is in `opts.opts`
  --     opts = {
  --       log_level = "DEBUG",
  --     },
  --   }
  -- },
}
