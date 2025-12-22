-- Minimal statusline theme
-- A clean, simple statusline with just the essentials

local C = require("statusline-compose.core.common")
local components = require("statusline-compose.components")

local M = {}

--- Assemble a minimal statusline with only essential information
--- Layout: [mode] [file] %= [lsp_status] [cursor]
---@return string The formatted minimal statusline
function M.run()
  -- Left: mode and file info only
  local left = C.join(" ", {
    components.mode(),
    components.file_info(),
  })

  -- Right: essentials
  local right = C.join(" ", {
    components.lsp_status(),
    components.cursor_position(true),  -- Show cursor position with totals
  })

  return left .. "%=" .. right
end

return M
