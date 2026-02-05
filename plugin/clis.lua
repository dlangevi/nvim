local function open_cli_buffer(name, cmd, use_current_pane)
  -- If there's only one window, always create a split (excluding nvim-tree)
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local num_windows = 0
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft ~= 'NvimTree' then
      num_windows = num_windows + 1
    end
  end
  if num_windows == 1 then
    use_current_pane = false
  end

  -- Find if there is already a buffer with this name
  local existing_buf = -1
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bname = vim.api.nvim_buf_get_name(buf)
    -- Check for exact match or path ending with name
    if bname:match("/" .. name .. "$") or bname == name then
      existing_buf = buf
      break
    end
  end

  if existing_buf ~= -1 and vim.api.nvim_buf_is_valid(existing_buf) then
    -- Check if the process is still running
    local ok, chan = pcall(vim.api.nvim_buf_get_var, existing_buf, "terminal_job_id")
    local running = false
    if ok then
      local res = vim.fn.jobwait({chan}, 0)[1]
      if res == -1 then
        running = true
      end
    end

    if running then
      -- If it exists and running, switch to it in current pane or existing window
      if use_current_pane then
        vim.api.nvim_win_set_buf(0, existing_buf)
      else
        local wins = vim.fn.win_findbuf(existing_buf)
        if #wins > 0 then
          vim.api.nvim_set_current_win(wins[1])
        else
          vim.cmd("rightbelow vsplit")
          vim.api.nvim_win_set_buf(0, existing_buf)
        end
      end
      vim.cmd("startinsert")
      return
    else
      -- If it exists but not running, we'll just create a new one (or we could reuse the buffer)
      -- To keep it simple and clean, let's delete the old one
      vim.api.nvim_buf_delete(existing_buf, { force = true })
    end
  end

  -- Create new buffer and open it in current pane or a vertical split
  if not use_current_pane then
    vim.cmd("rightbelow vsplit")
  end
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(0, buf)
  
  -- Start the terminal with the specified command
  vim.fn.termopen(cmd)
  
  -- Set the buffer name to exactly what was requested
  pcall(vim.api.nvim_buf_set_name, buf, name)
  
  -- Set buffer-local options
  vim.api.nvim_buf_set_option(buf, "buflisted", true)

  -- Terminal-local keymaps for navigation and escaping
  local opts = { buffer = buf, silent = true }
  -- Allow <Esc> to enter normal mode
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
  -- Respect your window navigation keybinds while in terminal mode
  vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
  vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
  vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
  vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)

  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Gemini", function()
  open_cli_buffer("gemini", "gemini", false)
end, {})

vim.api.nvim_create_user_command("Copilot", function()
  open_cli_buffer("copilot", "copilot", false)
end, {})

vim.api.nvim_create_user_command("GeminiHere", function()
  open_cli_buffer("gemini", "gemini", true)
end, {})

vim.api.nvim_create_user_command("CopilotHere", function()
  open_cli_buffer("copilot", "copilot", true)
end, {})
