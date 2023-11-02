-- local function changeLanguage(language)
--   return function()
--     vim.g.leetcode_solution_filetype = language
--   end
-- end
--
-- return {
--   'ianding1/leetcode.vim',
--   config = function()
--     local keymapper = require('keymapper')
--     vim.g.leetcode_browser = "firefox"
--     vim.g.leetcode_hide_paid_only = true
--     vim.g.leetcode_solution_filetype = "golang"
--
--     keymapper.register({
--       l = {
--         name = "LeetCode",
--         l = { "<cmd>LeetCodeList<cr>", "LeetCodeList" },
--         t = { "<cmd>LeetCodeTest<cr>", "LeetCodeTest" },
--         s = { "<cmd>LeetCodeSubmit<cr>", "LeetCodeSubmit" },
--         i = { "<cmd>LeetCodeSignIn<cr>", "LeetCodeSignIn" },
--         c = {
--           name = "Change Language",
--           g = { changeLanguage("golang"), "golang" },
--           j = { changeLanguage("javascript"), "javascript" },
--           p = { changeLanguage("python"), "python" },
--           c = { changeLanguage("c++"), "c++" },
--           r = { changeLanguage("rust"), "rust" },
--         },
--       }
--     }, { prefix = "<leader>" })
--   end
-- }

-- TODO setup as above
return {
  "Dhanus3133/LeetBuddy.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("leetbuddy").setup({})
  end,
  keys = {
    -- { "<leader>lq", "<cmd>LBQuestions<cr>", desc = "List Questions" },
    -- { "<leader>ll", "<cmd>LBQuestion<cr>", desc = "View Question" },
    -- { "<leader>lr", "<cmd>LBReset<cr>", desc = "Reset Code" },
    -- { "<leader>lt", "<cmd>LBTest<cr>", desc = "Run Code" },
    -- { "<leader>ls", "<cmd>LBSubmit<cr>", desc = "Submit Code" },
  },
}
