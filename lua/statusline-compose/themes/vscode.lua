-- VS Code themed statusline implementation
-- Combines modular components into a clean, VS Code-inspired statusline layout

local C = require("statusline-compose.core.common")
local components = require("statusline-compose.components")

local M = {}

--- Assemble the complete VS Code themed statusline
--- Layout structure:
---   [left] %=[center]%= [right]
---   - left: mode, file_info, git_branch, diagnostics
---   - center: lsp_progress (centered)
---   - right: git_changes, cursor_position, file_encoding, filetype, lsp_status, cwd
---
---@return string The complete formatted statusline
function M.run()
  -- Left section: information about the current file and mode
  local left = C.join("", {
    C.pad(components.mode()),
    C.pad(components.file_info()),
    C.pad(components.git_branch()),
    C.pad(components.lsp_diagnostics()),
  })

  -- Center section: LSP progress indicator
  local center = components.lsp_progress()

  -- Right section: metadata about the file and system
  local right = C.join(" ", {
    C.pad(components.git_changes(), "", " |"),
    components.cursor_position(),
    components.file_encoding(),
    components.filetype(),
    components.lsp_status(),
    components.cwd(),
  })

  return left .. "%=" .. center .. "%=" .. right
end

return M
