vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"Directory.*.props", "Directory.*.targets", "*.proj"},
  command = "set filetype=xml",
})
