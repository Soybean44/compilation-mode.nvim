local harpoon = require("harpoon")

local M = {}
local config = {
  send_window = "",
  send_pane = "1",
  do_swap = false,
  send_cmd = function(cmd, send_window, send_pane)
    return {
      "tmux",
      "send-keys",
      string.format('-t:%s.%s', send_window, send_pane),
      string.format('%s', cmd),
      "Enter",
    }
  end,
  swap_cmd = function(send_window, send_pane)
    return {
      "tmux",
      "select-window",
      string.format('-t:%s', send_window),
      ";",
      "select-pane",
      string.format('-t:%s', send_pane),
    }
  end
}

function M.RunCommand(cmd)
  local function get_os_command_output(input_cmd, cwd)
    if type(input_cmd) ~= "table" then
      print("Harpoon: [get_os_command_output]: input_cmd has to be a table")
      return {}
    end
    local Job = require("plenary.job")
    local command = table.remove(input_cmd, 1)
    local stderr = {}
    local stdout, ret = Job
        :new({
          command = command,
          args = input_cmd,
          cwd = cwd,
          on_stderr = function(_, data)
            table.insert(stderr, data)
          end,
        })
        :sync()
    return stdout, ret, stderr
  end
  if string.match(cmd, "$CURRENT_FILE") then
    -- Get the current buffer ID
    local buf_id = vim.api.nvim_get_current_buf()

    -- Get the file path of the current buffer
    local file_path = vim.api.nvim_buf_get_name(buf_id)
    cmd = string.gsub(cmd, "$CURRENT_FILE", file_path)
  end
  local _, ret, stderr = get_os_command_output(config.send_cmd(cmd, config.send_window, config.send_pane), vim.loop.cwd())
  print(string.format('sending command: %s', harpoon:list("cmd"):get(1).value))
  if ret ~= 0 then
    if stderr then
      error("Failed to send command. " .. stderr[1])
    end
  end
  if config.do_swap then
    local _, ret, stderr = get_os_command_output(config.swap_cmd(config.send_window, config.send_pane), vim.loop.cwd())
    print(string.format('sending command: %s', harpoon:list("cmd"):get(1).value))
    if ret ~= 0 then
      if stderr then
        error("Failed to send command. " .. stderr[1])
      end
    end
  end
end

function M.CompileModeAdd(cmd)
  print(string.format("Adding command: %s", cmd))
  harpoon:list("cmd"):prepend({ value = cmd })
end

function M.CompileModeAddEnd(cmd)
  print(string.format("Adding command: %s", cmd))
  harpoon:list("cmd"):add({ value = cmd })
end

function M.CompileModeClear()
  harpoon:list("cmd"):clear()
end

function M.CompileModeList()
  harpoon.ui:toggle_quick_menu(harpoon:list("cmd"))
end

function M.CompileModeSend(item)
  if item then
    harpoon:list("cmd"):select(item)
  else
    harpoon:list("cmd"):select(1)
  end
end

function M.setup(opts)
  -- Merge user options with defaults

  config.send_cmd = opts.send_cmd or config.send_cmd
  config.swap_cmd = opts.swap_cmd or config.swap_cmd
  config.do_swap = opts.do_swap or config.do_swap
  config.send_window = opts.send_window or config.send_window
  config.send_pane = opts.send_pane or config.send_pane

  harpoon:setup({
    settings = {
      sync_on_ui_close = true,
    },
    ["cmd"] = {
      select = function(list_item, list, option)
        M.RunCommand(list_item.value)
      end
    }
  })

  -- Define User Commands
  vim.api.nvim_create_user_command("CompileModeAdd", function(opts)
    M.CompileModeAdd(opts.args)
  end, { nargs = '?' })
  vim.api.nvim_create_user_command("CompileModeAddEnd", function(opts)
    M.CompileModeAddEnd(opts.args)
  end, { nargs = '?' })

  vim.api.nvim_create_user_command("CompileModeClear", function()
    harpoon:list("cmd"):clear()
  end, {})

  vim.api.nvim_create_user_command("CompileModeList", function()
    harpoon.ui:toggle_quick_menu(harpoon:list("cmd"))
  end, {})

  vim.api.nvim_create_user_command("CompileModeSend", function(opts)
    if #opts.fargs >= 1 then
      M.CompileModeSend(tonumber(opts.fargs[1]))
    else
      M.CompileModeSend()
    end
  end, { nargs = '?' })
end

return M
