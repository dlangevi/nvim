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

      local function getInstallPath(package)
        local registry = require("mason-registry")
        return registry.get_package(package):get_install_path()
      end

      dap.adapters.netcoredbg = {
        type = 'executable',
        command = getInstallPath("netcoredbg") .. "/netcoredbg",
        args = { '--interpreter=vscode' }
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
        },
      }

      wk.register({
        b = {
          name = "breakpoints",
          t = { dap.toggle_breakpoint, "Toggle breakpoint" },
        }
      }, { prefix = "<leader>" })

      wk.register({
        da = {
          name = "DAP UI",
          o = { dapui.open, "Open dap ui" },
          c = { dapui.close, "Close dap ui" },
          t = { dapui.toggle, "Toggle dap ui" },
        }
      }, { prefix = "<leader>" })

      wk.register({
        t = {
          name = "tests",
          r = { neotest.run.run, "Run Test" },
          e = { function()
            neotest.run.run({ strategy = "dap" })
          end, "Run Test with DAP" },
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
    config = function()
      local coverage = require("coverage")
      coverage.setup({
        lcov_file = 'coveragereport/lcov.info'
      })

      wk.register({
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
