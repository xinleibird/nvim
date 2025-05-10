---@diagnostic disable: param-type-mismatch
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
    vim.cmd("lopen|wincmd J")
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

------------------------
-- https://github.com/mfussenegger/nvim-dap/discussions/671
-- After extracting cargo's compiler metadata with the cargo inspector
-- parse it to find the binary to debug
local function parse_cargo_metadata(cargo_metadata)
  -- Iterate backwards through the metadata list since the binary
  -- we're interested will be near the end (usually second to last)
  for i = 1, #cargo_metadata do
    local json_table = cargo_metadata[#cargo_metadata + 1 - i]

    -- Some metadata lines may be blank, skip those
    if string.len(json_table) ~= 0 then
      -- Each matadata line is a JSON table,
      -- parse it into a data structure we can work with
      json_table = vim.fn.json_decode(json_table)

      -- Our binary will be the compiler artifact with an executable defined
      if json_table["reason"] == "compiler-artifact" and json_table["executable"] ~= vim.NIL then
        return json_table["executable"]
      end
    end
  end

  return nil
end

-- Parse the `cargo` section of a DAP configuration and add any needed
-- information to the final configuration to be handed back to the adapter.
-- E.g.: When debugging a test, cargo generates a random executable name.
-- We need to ask cargo for the name and add it to the `program` config field
-- so LLDB can find it.
M.cargo_inspector = function(config)
  local final_config = vim.deepcopy(config)

  -- Create a buffer to receive compiler progress messages
  local compiler_msg_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_var(compiler_msg_buf, "buftype", "nofile")

  -- And a floating window in the corner to display those messages
  local window_width = math.max(#final_config.name + 1, 50)
  local window_height = 12
  local compiler_msg_window = vim.api.nvim_open_win(compiler_msg_buf, false, {
    relative = "editor",
    width = window_width,
    height = window_height,
    col = vim.api.nvim_get_option_value("columns", {}) - window_width - 1,
    row = vim.api.nvim_get_option_value("lines", {}) - window_height - 1,
    border = "rounded",
    style = "minimal",
  })

  -- Let the user know what's going on
  vim.fn.appendbufline(compiler_msg_buf, "$", "Compiling: ")
  vim.fn.appendbufline(compiler_msg_buf, "$", final_config.name)
  vim.fn.appendbufline(compiler_msg_buf, "$", string.rep("=", window_width - 1))

  -- Instruct cargo to emit compiler metadata as JSON
  local message_format = "--message-format=json"
  if final_config.cargo.args ~= nil then
    table.insert(final_config.cargo.args, message_format)
  else
    final_config.cargo.args = { message_format }
  end

  -- Build final `cargo` command to be executed
  local cargo_cmd = { "cargo" }
  for _, value in pairs(final_config.cargo.args) do
    table.insert(cargo_cmd, value)
  end

  -- Run `cargo`, retaining buffered `stdout` for later processing,
  -- and emitting compiler messages to to a window
  local compiler_metadata = {}
  local cargo_job = vim.fn.jobstart(cargo_cmd, {
    clear_env = false,
    env = final_config.cargo.env,
    cwd = final_config.cwd,

    -- Cargo emits compiler metadata to `stdout`
    stdout_buffered = true,
    on_stdout = function(_, data)
      compiler_metadata = data
    end,

    -- Cargo emits compiler messages to `stderr`
    on_stderr = function(_, data)
      local complete_line = ""

      -- `data` might contain partial lines, glue data together until
      -- the stream indicates the line is complete with an empty string
      for _, partial_line in ipairs(data) do
        if string.len(partial_line) ~= 0 then
          complete_line = complete_line .. partial_line
        end
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.fn.appendbufline(compiler_msg_buf, "$", complete_line)
        vim.api.nvim_win_set_cursor(compiler_msg_window, { vim.api.nvim_buf_line_count(compiler_msg_buf), 1 })
        vim.cmd("redraw")
      end
    end,

    on_exit = function(_, exit_code)
      -- Cleanup the compile message window and buffer
      if vim.api.nvim_win_is_valid(compiler_msg_window) then
        vim.api.nvim_win_close(compiler_msg_window, { force = true })
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.api.nvim_buf_delete(compiler_msg_buf, { force = true })
      end

      -- If compiling succeeed, send the compile metadata off for processing
      -- and add the resulting executable name to the `program` field of the final config
      if exit_code == 0 then
        local executable_name = parse_cargo_metadata(compiler_metadata)
        if executable_name ~= nil then
          final_config.program = executable_name
        else
          vim.notify(
            "Cargo could not find an executable for debug configuration:\n\n\t" .. final_config.name,
            vim.log.levels.ERROR
          )
        end
      else
        vim.notify("Cargo failed to compile debug configuration:\n\n\t" .. final_config.name, vim.log.levels.ERROR)
      end
    end,
  })

  -- Get the rust compiler's commit hash for the source map
  local rust_hash = ""
  local rust_hash_stdout = {}
  local rust_hash_job = vim.fn.jobstart({ "rustc", "--version", "--verbose" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data)
      rust_hash_stdout = data
    end,
    on_exit = function()
      for _, line in pairs(rust_hash_stdout) do
        local start, finish = string.find(line, "commit-hash: ", 1, true)

        if start ~= nil then
          rust_hash = string.sub(line, finish + 1)
        end
      end
    end,
  })

  -- Get the location of the rust toolchain's source code for the source map
  local rust_source_path = ""
  local rust_source_job = vim.fn.jobstart({ "rustc", "--print", "sysroot" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data)
      rust_source_path = data[1]
    end,
  })

  -- Wait until compiling and parsing are done
  -- This blocks the UI (except for the :redraw above) and I haven't figured
  -- out how to avoid it, yet
  -- Regardless, not much point in debugging if the binary isn't ready yet
  vim.fn.jobwait({ cargo_job, rust_hash_job, rust_source_job })

  -- Enable visualization of built in Rust datatypes
  final_config.sourceLanguages = { "rust" }

  -- Build sourcemap to rust's source code so we can step into stdlib
  rust_hash = "/rustc/" .. rust_hash .. "/"
  rust_source_path = rust_source_path .. "/lib/rustlib/src/rust/"
  if final_config.sourceMap == nil then
    final_config["sourceMap"] = {}
  end
  final_config.sourceMap[rust_hash] = rust_source_path

  -- Cargo section is no longer needed
  final_config.cargo = nil

  return final_config
end

return M
