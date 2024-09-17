local attach_to_buffer = function(bufnr, command, pattern)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("autorunner", { clear = true }),
    pattern = pattern,
    callback = function()
      local output = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data);
        end
      end
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "output of: ts file" });
      vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = output,
        on_stderr = output,

      })
    end,

  })
end

vim.api.nvim_create_user_command("AttachRunner", function()
  local winAfter = vim.api.nvim_get_current_win()
  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(winAfter, buf)
  vim.api.nvim_set_current_win(winAfter);
  local bufnr = vim.api.nvim_get_current_buf();
  vim.api.nvim_set_current_win(win);
  attach_to_buffer(bufnr, { "deno", "run", "--allow-net", "test.ts" }, "*.ts");
end, {})
