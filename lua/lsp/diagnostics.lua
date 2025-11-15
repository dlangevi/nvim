local M = {}

local hintsHidden = true
local severity = {
  min = vim.diagnostic.severity.WARN
}

local function updateDiagnostics()
  vim.diagnostic.config({
    underline = {
      severity = severity
    },
    virtual_text = {
      severity = severity
    }
  })
end
updateDiagnostics()

function M.disableSuggestions()
  severity.min = vim.diagnostic.severity.WARN
  updateDiagnostics()
  hintsHidden = true
end

function M.enableSuggestions()
  severity.min = vim.diagnostic.severity.HINT
  updateDiagnostics()
  hintsHidden = false
end

function M.toggleSuggestions()
  if hintsHidden then
    M.enableSuggestions()
  else
    M.disableSuggestions()
  end
end

function M.goto_next()
  vim.diagnostic.goto_next({
    severity = severity
  })
end

function M.goto_prev()
  vim.diagnostic.goto_prev({
    severity = severity
  })
end

function M.setup_keymaps()
  local wk = require('which-key')
  wk.add({
    { "<leader>d",  group = "diagnostics" },
    { "<leader>dd", M.disableSuggestions,        desc = "Disable Suggestions" },
    { "<leader>de", M.enableSuggestions,         desc = "Enable Suggestions" },
    { "<leader>df", vim.diagnostic.open_float,   desc = "Open floating diagnostics" },
    { "<leader>dn", M.goto_next,                 desc = "Go to next diagnostic" },
    { "<leader>dp", M.goto_prev,                 desc = "Go to previous diagnostic" },
    { "<leader>dq", vim.diagnostic.setloclist,   desc = "Open fixlist diagnostics" },
    { "<leader>dt", M.toggleSuggestions,         desc = "Toggle Suggestions" },
  })
end

return M
