# compilation-mode.nvim

After watching the youtuber [Tsoding](https://youtube.com/tsodingdaily), I found him using this feature called compilation mode in emacs. It looked really cool and I decided to put together a haphazard plugin to emulate this behaviour.

The functionality of this plugin mimicks the workflow of [harpoon](https://github.com/ThePrimeagen/harpoon), and if you aren't on harpoon2, good news this is built into the plugin so you don't need to rely on my spaghetti code. If you are on the new version, then you have come to the right place.

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

| Lua                                       | Command                  | Description                                                        |
| ----------------------------------------- | ------------------------ | ------------------------------------------------------------------ |
| `compilation_mode.CompileModeAdd(cmd)`    | `:CompileModeAdd cmd`    | Adds a new command to the top of the command list                  |
| `compilation_mode.CompileModeAddEnd(cmd)` | `:CompileModeAddEnd cmd` | Adds a new command to the bottom of the command list               |
| `compilation_mode.CompileModeClear()`     | `:CompileModeClear`      | Clears the command list                                            |
| `compilation_mode.CompileModeList()`      | `:CompileModeList`       | Opens the command list                                             |
| `compilation_mode.CompileModeSend(item)`  | `:CompileModeSend item`  | Sends the specified item in the command list to the next tmux pane |

Note that `:CompileModeSend` will send the first item (top item) in the command list when an argument is not specified

## Configuration

TBD
