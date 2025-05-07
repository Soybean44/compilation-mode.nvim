---
--- Title: compilation-mode.nvim
--- Desc: Main file for the compilation-mode.nvim plugin
--- Author: Soybean44
---

local M = {}

-- Function to print the hello message
function M.say_hello()
  print("Hello from Neovim!")
end

-- Function to set up the plugin (Most package managers expect the plugin to have a setup function)
function M.setup(opts)
  -- Merge user options with defaults
  opts = opts

  vim.api.nvim_create_user_command("HelloWorld", M.say_hello, {})
end
