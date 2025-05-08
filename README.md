# compilation-mode.nvim

- [Description](#Description)
- [Instalation](#Instalation)
- [Usage](#Usage)
- [Configuration](#Configuration) (TBD)

## Description

After watching the youtuber [Tsoding](https://youtube.com/tsodingdaily), I found him using this feature called compilation mode in emacs. It looked really cool and I decided to put together a haphazard plugin to emulate this behaviour.

The functionality of this plugin mimicks the workflow of [harpoon](https://github.com/ThePrimeagen/harpoon), and if you aren't on harpoon2, good news this is built into the plugin so you don't need to rely on my spaghetti code, . If you are on the new version, then you have come to the right place.

## Instalation

To install the plugin add this to your Lazy.nvim configuration.

```lua
{
  "Soybean44/compilation-mode.nvim",
  lazy = false -- use this if you have lazyloading on by default
  dependencies = { "nvim-lua/plenary.nvim", "ThePrimeagen/harpoon" },
  config = function()
    local compilation_mode = require("compilation-mode")
    compilation_mode.setup() -- you MUST call setup

    -- example keybinds
    vim.keymap.set("n", "<M-c>", function()
      compilation_mode.CompileModeList()
    end)
    vim.keymap.set("n", "<M-r>", function()
      compilation_mode.CompileModeSend()
    end)
  end
}
```

If you are using any other plugin manager it should be fairly similar

## Usage

Typical useage is with the command `:CompileModeAdd <cmd>` or by editing the harpoon list from `:CompileModeList`. Every command has a corresponding lua function in the library as shown in the example config. The list of functions are as follows

| Lua                                       | Command                  | Description                                                          |
| ----------------------------------------- | ------------------------ | -------------------------------------------------------------------- |
| `compilation_mode.CompileModeAdd(cmd)`    | `:CompileModeAdd cmd`    | Adds a new command to the top of the command list                    |
| `compilation_mode.CompileModeAddEnd(cmd)` | `:CompileModeAddEnd cmd` | Adds a new command to the bottom of the command list                 |
| `compilation_mode.CompileModeClear()`     | `:CompileModeClear`      | Clears the command list                                              |
| `compilation_mode.CompileModeList()`      | `:CompileModeList`       | Opens the command list                                               |
| `compilation_mode.CompileModeSend(item)`  | `:CompileModeSend item`  | Sends the specified item in the command list to the target tmux pane |
| `compilation_mode.RunCommand(cmd)`        | `:RunCommand cmd`        | Sends the command passed in to the target tmux pane                  |

Note that `:CompileModeSend` will send the first item (top item) in the command list when an argument is not specified

## Configuration

Inside the setup function you can specify options. The default options are as follows

```lua
{
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
```

`send_window` and `send_pane` are what most users will configure to target their pane and window. These must be strings and an empty string will default to the current pane/window (though it is unlikely a user will want to send text to the current pane the option is there).
`send_cmd` and `swap_cmd` is used if you want to twek how the command is send. I personally have no experience with other terminal multiplexers but it could be used to configure them. These are lists of arguments to the command, where each element in the final command will be appended by spaces
`do_swap` is a boolean which enables the swap command. It is off by default but if you want to automatically swap to the target pane (i.e. to pass user input) it can be handy.

The default pane will be the pane with id 1 (pane id's found by doing `prefix q` in tmux) in your current window and you can configure this to your liking
