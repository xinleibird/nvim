local M = {}

M.detect_os = function()
  if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
    return "macos"
  end

  if vim.fn.has("win32") == 1 then
    return "windows"
  end

  if vim.fn.has("wsl") == 1 then
    return "wsl"
  end

  if vim.fn.has("unix") == 1 then
    return "linux"
  end

  vim.notify("Can not detect your OS")
end

M.detect_term = function()
  return vim.api.nvim_get_chan_info(vim.api.nvim_list_uis()[1].chan).client.name
end

M.detect_dark_mode = function()
  local modes = {
    macos = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light"):gsub("\n", ""):lower(),
    windows = vim.fn
      .system(
        'reg.exe query "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v AppsUseLightTheme'
      )
      :gsub("\r\n", "")
      :sub(-1)
          == 1
        and "light"
      or "dark",
    wsl = vim.fn
      .system(
        'reg.exe query "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v AppsUseLightTheme'
      )
      :gsub("\r\n", "")
      :sub(-1)
          == 1
        and "light"
      or "dark",
    linux = "dark",
  }

  local mode = modes[M.detect_os()]

  return mode
end

M.quickfix_toggle = function()
  local no_qf = vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix"))
  if no_qf == 1 then
    -- vim.cmd("rightbelow copen")
    vim.cmd("copen|wincmd J")
  else
    vim.cmd("cclose")
  end
end

M.loclist_toggle = function()
  local no_ll = vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.loclist"))
  if no_ll == 1 then
    if next(vim.fn.getloclist(0)) == nil then
      vim.notify("loclist empty!", vim.log.levels.INFO, { title = "loclist" })
      -- print("loclist empty!")
      return
    end
    -- vim.cmd("rightbelow lopen")
    vim.cmd("lopen")
  else
    vim.cmd("lclose")
  end
end

M.any_qf_lc_open = function()
  local no_qf = vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix"))
  local no_ll = vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.loclist"))

  if no_qf == 1 and no_ll == 1 then
    return false
  end
  return true
end

M.any_terminal_open = function()
  local no_term = vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.terminal"))
  if no_term == 1 then
    return false
  end
  return true
end

M.any_sidebar_open = function()
  local sidebar_found = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if string.find(bufname, "NvimTree") then
      sidebar_found = true
      break
    end

    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft == "snacks_layout_box" then
      sidebar_found = true
      break
    end
  end
  return sidebar_found
end

M.buf_kill = function(kill_command, bufnr, force)
  kill_command = kill_command or "bd"

  local bo = vim.bo
  local api = vim.api
  local fmt = string.format
  local fn = vim.fn

  if bufnr == 0 or bufnr == nil then
    bufnr = api.nvim_get_current_buf()
  end

  local bufname = api.nvim_buf_get_name(bufnr)
  local buftype = vim.bo[bufnr].buftype

  if not force then
    local choice
    if bo[bufnr].modified then
      choice = fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
      if choice == 1 then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("w")
        end)
      elseif choice == 2 then
        force = true
      else
        return
      end
    elseif buftype == "terminal" or buftype == "quickfix" or buftype == "loclist" then
      choice = fn.confirm(fmt([[Close "%s"?]], bufname), "&Yes\n&No\n&Cancel")
      if choice == 1 then
        force = true
      else
        return
      end
    end
  end

  -- Get list of windows IDs with the buffer to close
  local windows = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == bufnr
  end, api.nvim_list_wins())

  if force then
    kill_command = kill_command .. "!"
  end

  -- Get list of active buffers
  local buffers = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
  end, api.nvim_list_bufs())

  -- If there is only one buffer (which has to be the current one), vim will
  -- create a new buffer on :bd.
  -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
  if #buffers > 1 and #windows > 0 then
    for i, v in ipairs(buffers) do
      if v == bufnr then
        local prev_buf_idx = i == 1 and #buffers or (i - 1)
        local prev_buffer = buffers[prev_buf_idx]
        for _, win in ipairs(windows) do
          api.nvim_win_set_buf(win, prev_buffer)
        end
      end
    end
  end

  -- Check if buffer still exists, to ensure the target buffer wasn't killed
  -- due to options like bufhidden=wipe.
  if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
    vim.cmd(string.format("%s %d", kill_command, bufnr))
  end
end

return M
