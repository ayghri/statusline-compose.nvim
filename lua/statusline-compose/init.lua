local config = require("statusline-compose.config")

Statusline = Statusline or config

local M = {}

--- Setup the statusline plugin
---@param opts table|nil User configuration options
---   - theme: string (default: "vscode") - Built-in theme to use
---   - statusline: function (optional) - Custom statusline function (overrides theme)
---                                       receives components and common modules
---   - Other config options: position_min_width, cursor_position_show_total, icons, etc.
function M.setup(opts)
  -- opts = opts or {}

  -- Initialize global Statusline table if it doesn't exist
  -- Statusline = Statusline or {}

  -- Store the custom statusline function if provided
  -- local custom_statusline = opts.statusline

  -- Merge user options with defaults (excluding the statusline function)
  Statusline = vim.tbl_deep_extend("force", Statusline, opts)

  -- Set LSP progress length if specified
  if Statusline.lsprogress_len then
    vim.g.lsprogress_len = Statusline.lsprogress_len
  end

  -- Set the statusline
  if custom_statusline then
    -- Use custom statusline function provided in config
    -- Make components and common available globally for the custom function
    _statusline_custom = custom_statusline
    vim.opt.statusline = "%!v:lua._statusline_custom()"
  else
    -- Use theme-based statusline
    vim.opt.statusline = "%!v:lua.require('statusline-compose.themes."
        .. Statusline.theme
        .. "').run()"
  end
end

return M
