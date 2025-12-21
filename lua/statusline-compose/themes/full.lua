-- Full-featured statusline theme
-- A comprehensive statusline with all available components

local C = require("statusline-compose.core.common")
local components = require("statusline-compose.components")

local M = {}

--- Assemble a full-featured statusline with all available information
--- Layout: [mode] [file] [branch] [diagnostics] %= [progress] %= [changes] [pos] [encoding] [filetype] [lsp] [cwd]
---@return string The formatted full statusline
function M.run()
  -- Left section: file and mode information
  local left = C.join("", {
    C.pad(components.mode()),
    C.pad(components.file_info()),
    C.pad(components.git_branch()),
    C.pad(components.lsp_diagnostics()),
  })

  -- Center section: LSP progress
  local center = components.lsp_progress()

  -- Right section: all metadata
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
