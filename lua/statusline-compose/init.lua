local config = require("statusline-compose.config")

local M = {}

--- Setup the statusline plugin
---@param opts table|nil User configuration options
function M.setup(opts)
	-- Initialize global Statusline table if it doesn't exist
	Statusline = Statusline or {}

	-- Merge user options with defaults
	Statusline.opts = vim.tbl_deep_extend("force", config.defaults, opts or {})

	-- Set LSP progress length if specified
	if Statusline.opts.lsprogress_len then
		vim.g.lsprogress_len = Statusline.opts.lsprogress_len
	end

	-- Set the statusline to use the specified theme
	vim.opt.statusline = "%!v:lua.require('statusline-compose.themes."
		.. Statusline.opts.theme
		.. "').run()"
end

return M
