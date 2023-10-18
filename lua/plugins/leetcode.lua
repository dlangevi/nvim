local function changeLanguage(language)
  return function()
    vim.g.leetcode_solution_filetype = language
  end
end

return {
  'ianding1/leetcode.vim',
  config = function()
    local keymapper = require('keymapper')
    vim.g.leetcode_browser = "firefox"
    vim.g.leetcode_hide_paid_only = true
    vim.g.leetcode_solution_filetype = "golang"

    keymapper.register({
      l = {
        name = "LeetCode",
        l = { "<cmd>LeetCodeList<cr>", "LeetCodeList" },
        t = { "<cmd>LeetCodeTest<cr>", "LeetCodeTest" },
        s = { "<cmd>LeetCodeSubmit<cr>", "LeetCodeSubmit" },
        i = { "<cmd>LeetCodeSignIn<cr>", "LeetCodeSignIn" },
        c = {
          name = "Change Language",
          g = { changeLanguage("golang"), "golang" },
          j = { changeLanguage("javascript"), "javascript" },
          p = { changeLanguage("python"), "python" },
          c = { changeLanguage("c++"), "c++" },
          r = { changeLanguage("rust"), "rust" },
        },
      }
    }, { prefix = "<leader>" })
  end
}
