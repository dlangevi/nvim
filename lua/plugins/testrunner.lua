local keymapper = require('keymapper')

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "Issafalcon/neotest-dotnet"
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-dotnet")
        },
        output = {
          open_on_run = false
        }

      })

      keymapper.register({
        t = {
          name = "tests",
          r = { neotest.run.run, "Run Test" },
          d = { neotest.output_panel.toggle, "Toggle Ouput Panel" },
          c = { neotest.output_panel.clear, "Clear Output Panel" },
          f = { neotest.output.open, "Display Float" },
          s = { neotest.summary.toggle, "Toggle Summary" },
        }
      }, { prefix = "<leader>" })
    end
  },
  {
    "andythigpen/nvim-coverage",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      local coverage = require("coverage")
      coverage.setup({
        lcov_file = 'coveragereport/lcov.info'
      })

      keymapper.register({
        c = {
          name = "coverage",
          l = { coverage.load_lcov, "Load lcov file" },
          t = { coverage.toggle, "Toggle coverage" },
          s = { coverage.show, "Show coverage" },
          h = { coverage.hide, "Hide coverage" },
        }
      }, { prefix = "<leader>" })
    end,
  },
}
