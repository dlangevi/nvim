local wk = require('which-key')

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "Issafalcon/neotest-dotnet",
      "rcarriga/nvim-dap-ui"
    },
    config = function()
      local neotest = require("neotest")
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      neotest.setup({
        adapters = {
          require("neotest-dotnet")({
            -- dotnet_additional_args = {
            --   "--verbosity detailed"
            -- },
            custom_attributes = {
              xunit = { "WindowsOnlyTest" },
            },
          })
        },
        output = {
          open_on_run = false
        }
      })

      -- local function getInstallPath(package)
      --   local registry = require("mason-registry")
      --   return registry.get_package(package):get_install_path()
      -- end
      --
      -- dap.adapters.netcoredbg = {
      --   type = 'executable',
      --   command = getInstallPath("netcoredbg") .. "/netcoredbg",
      --   args = { '--interpreter=vscode' }
      -- }

      -- dap.configurations.cs = {
      --   {
      --     type = "coreclr",
      --     name = "launch - netcoredbg",
      --     request = "launch",
      --     program = function()
      --       return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      --     end,
      --   },
      -- }

      wk.add({
        { "<leader>b",   group = "breakpoints" },
        { "<leader>bt",  dap.toggle_breakpoint,                                desc = "Toggle breakpoint" },

        { "<leader>da",  group = "DAP UI" },
        { "<leader>dac", dapui.close,                                          desc = "Close dap ui" },
        { "<leader>dao", dapui.open,                                           desc = "Open dap ui" },
        { "<leader>dat", dapui.toggle,                                         desc = "Toggle dap ui" },

        { "<leader>t",   group = "tests" },
        { "<leader>tc",  neotest.output_panel.clear,                           desc = "Clear Output Panel" },
        { "<leader>td",  neotest.output_panel.toggle,                          desc = "Toggle Ouput Panel" },
        { "<leader>tf",  neotest.output.open,                                  desc = "Display Float" },
        { "<leader>tr",  neotest.run.run,                                      desc = "Run Test" },
        { "<leader>ts",  neotest.summary.toggle,                               desc = "Toggle Summary" },
        { "<leader>te",  function() neotest.run.run({ strategy = "dap" }) end, desc = "Run Test with DAP" },
      })
    end
  },
  {
    "andythigpen/nvim-coverage",
    config = function()
      local coverage = require("coverage")
      coverage.setup({
        lcov_file = './coveragereport/lcov.info'
      })

      wk.add({
        { "<leader>c",  group = "coverage" },
        { "<leader>ch", coverage.load_lcov, desc = "Hide coverage" },
        { "<leader>cl", coverage.hide,      desc = "Load lcov file" },
        { "<leader>cs", coverage.show,      desc = "Show coverage" },
        { "<leader>ct", coverage.toggle,    desc = "Toggle coverage" },
      })
    end,
  },
}
