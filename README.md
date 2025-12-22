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

### Basic Options

```lua
require("statusline-compose").setup({
  -- Theme to use (default: "vscode")
  theme = "vscode",

  -- Display options
  position_min_width = 140,           -- Min terminal width to show cursor position
  git_changes_min_width = 120,        -- Min terminal width to show git changes
  LSP_progress_min_width = 120,       -- Min terminal width to show LSP progress

  -- Icons configuration
  icons = {
    modified = "",
    mode = "",
    default_file = "󰈚",
    git_branch = "",
    cwd = "󰉖",
    git_changes = { added = "+", changed = "-", removed = "x" },
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

### Inline Statusline Definition

You can also define your statusline directly in the config without creating a separate file:

```lua
require("statusline-compose").setup({
  -- Define statusline function inline
  statusline = function()
    local C = require("statusline-compose.core.common")
    local components = require("statusline-compose.components")

    local left = C.join("", {
      C.pad(components.mode()),
      C.pad(components.file_info()),
    })

    local right = C.join(" ", {
      components.cursor_position(true),  -- true = show totals (default)
      components.lsp_status(),
    })

    return left .. "%=" .. right
  end,
})
```

This approach is great for simple customizations. For more complex statuslines, create a separate theme file.

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
- `components.cursor_position(show_total)` - Line and column position
  - `show_total` (boolean, default: true): Include total lines/columns
    - `true`: "Ln 10/100, Cl 5/80"
    - `false`: "Ln 10, Cl 5"
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
    components.cursor_position(true),  -- Show totals
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
- `C.get_file_info()` - Get file name and icon (uses nvim-web-devicons if available)
- `C.get_filetype()` - Get file type
- `C.get_branch()` - Get git branch name (uses gitsigns API)
- `C.get_changes()` - Get git changes (uses gitsigns API)
  - Returns table with `added`, `changed`, `removed` counts
  - Returns `nil` if gitsigns not available or not in a git repo
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
    └── minimal.lua       # Minimal theme
```

## Requirements

- Neovim >= 0.9
- Optional: [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for file icons (enables filetype icons in file info)
- Optional: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for git integration (enables branch name and file changes)

### Recommended Setup

For the best experience, install with optional dependencies:

```lua
{
  "ayghri/statusline-compose.nvim",
  opts = { theme = "vscode" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
}
```

**Note**: The plugin gracefully handles missing dependencies. If gitsigns or web-devicons aren't installed, those components will simply display without icons or git information.

## Demo

![statusline](./doc/themes/vscode.png)
