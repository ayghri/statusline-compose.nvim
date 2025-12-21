# statusline-compose

A modular Neovim statusline plugin with composable components. Build custom statuslines by combining reusable components together.
This was inspired by the statusline from NvChad/ui.

## Features

- **Composable Components**: Build custom statuslines by combining reusable components
- **Git Integration**: Shows branch name and file changes (added, changed, removed)
- **LSP Support**: Displays connected language server and diagnostic counts
- **Mode Indicator**: Shows current Vim mode with color-coded highlighting
- **File Info**: File name with icon support via nvim-web-devicons
- **Cursor Position**: Line and column information with file length
- **LSP Progress**: Shows language server progress with animated spinner
- **File Encoding**: Displays current file encoding
- **Working Directory**: Shows current working directory

## Installation

### Lazy.nvim

```lua
{
  "ayghri/statusline-compose.nvim",
  opts = {
    theme = "vscode"
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file type icons
  },
}
```

## Configuration

```lua
require("statusline-compose").setup({
  theme = "vscode",
  position_min_width = 140,
  git_changes_min_width = 120,
  LSP_progress_min_width = 120,
  icons = {
    modified = "",
    mode = "",
    default_file = "󰈚",
    git_branch = "",
    cwd = "󰉖",
    git_changes = { added = "", changed = "", removed = "" },
    lsp = "󰄭",
    diagnostics = {
      error = "󰅚",
      warn = "",
      hint = "󰛩",
      info = "",
    },
    spinners = {
      "",
      "󰪞",
      "󰪟",
      "󰪠",
      "󰪢",
      "󰪣",
      "󰪤",
      "󰪥",
    },
  },
})
```

## Creating Custom Statuslines

The plugin provides a modular component system, making it easy to create custom statuslines.

### Available Components

All components are located in `lua/statusline-compose/components.lua`:

- `components.mode()` - Current vim mode with icon
- `components.file_info()` - Filename with filetype icon
- `components.filetype()` - File type
- `components.git_branch()` - Current git branch
- `components.git_changes()` - Git changes (added/changed/removed)
- `components.lsp_diagnostics()` - Diagnostic counts (errors/warnings/hints/info)
- `components.lsp_progress()` - LSP server progress with spinner
- `components.lsp_status()` - Connected LSP client name
- `components.cursor_position()` - Line, column, and line length
- `components.file_encoding()` - Current file encoding
- `components.cwd()` - Current working directory

### Example: Create Your Own Theme

Create a new theme file `lua/statusline-compose/themes/custom.lua`:

```lua
-- Custom minimal statusline theme
local C = require("statusline-compose.core.common")
local components = require("statusline-compose.components")

local M = {}

function M.run()
  -- Minimal left section
  local left = C.join(" ", {
    components.mode(),
    components.file_info(),
  })

  -- Right section with essentials
  local right = C.join(" ", {
    components.lsp_status(),
    components.cursor_position(),
  })

  return left .. "%=" .. right
end

return M
```

Then use it in your config:

```lua
require("statusline-compose").setup({
  theme = "custom"
})
```

### Common Module (Data & Utilities)

Functions from `lua/statusline-compose/core/common.lua`:

**Utilities (for string manipulation):**
- `C.join(separator, elements)` - Concatenate elements with separator
- `C.pad(text, left_pad, right_pad)` - Add padding around highlight groups
- `C.sub_empty(value, default)` - Replace empty strings with default
- `C.get_cyclic_counter(max)` - Get animation counter for spinners

**Data Retrieval (returns unformatted data):**
- `C.get_mode()` - Get current mode and highlight group
- `C.get_cwd()` - Get current working directory
- `C.get_file_info()` - Get file name and icon
- `C.get_filetype()` - Get file type
- `C.get_branch()` - Get git branch name
- `C.get_changes()` - Get git changes (added/changed/removed)
- `C.get_lsp_client()` - Get connected LSP client name
- `C.get_diagnostics()` - Get diagnostic counts
- `C.get_lsp_message()` - Get LSP progress message
- `C.count_severity(level)` - Count diagnostics by severity

## Example Themes

The plugin includes three example themes to help you get started:

- **vscode** (default) - Full-featured VS Code-inspired theme with all components
- **minimal** - Simple theme with just mode, file info, and essentials

Try them with:
```lua
require("statusline-compose").setup({ theme = "minimal" })
```

## Folder Structure

**Modular Architecture:**
```
lua/statusline-compose/
├── init.lua              # Plugin setup and initialization
├── config.lua            # Default configuration and icons
│
├── core/                 # Layer 1: Data & Utilities
│   ├── common.lua        # Data retrieval + helper functions
│   └── modes.lua         # Vim mode definitions
├── components.lua        # Layer 2: Formatted Components
└── themes/               # Layer 3: Composed Statuslines
    ├── vscode.lua        # VS Code theme (default)
    ├── minimal.lua       # Minimal theme
    └── full.lua          # Full-featured theme
```

## Requirements

- Neovim >= 0.9
- Optional: [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for file icons
- Optional: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for git integration

## Demo

![statusline](./doc/themes/vscode.png)
