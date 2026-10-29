-- Common utility functions for statusline
-- Low-level helpers for string manipulation and animation

local fn = vim.fn
local Mods = require("statusline-compose.core.modes")
local M = {}
local lsp_errors = {}

--- Count diagnostics of a given severity in the current buffer
---@param severity number The severity level to count
---@return number The count of diagnostics matching the severity
function M.count_severity(severity)
  local a = #vim.diagnostic.get(0, { severity = severity })
  return ((a and a > 0) and a) or 0
end

--- Get a cyclic counter for animations (used by spinner)
---@param max_counter number The maximum value to cycle to
---@return number The current counter value (0 to max_counter-1)
function M.get_cyclic_counter(max_counter)
  local ms = vim.loop.hrtime() / 1000000
  return math.floor(ms / 120) % max_counter
end

--- Concatenate elements with separator
---@param char string The separator character
---@param elements table Array of elements to concatenate
---@return string The concatenated string
function M.join(char, elements)
  return table.concat(elements, char)
end

--- Add padding to text around highlight delimiters
--- Replaces "%#?#A%#B#" -> "%#?#" .. left_p .. "A%#B#" .. right_p
---@param text string The text with highlight delimiters
---@param left_p string|nil Left padding (default: space)
---@param right_p string|nil Right padding (default: space)
---@return string The padded text
function M.pad(text, left_p, right_p)
  if text == "" then
    return ""
  end
  return string.gsub(text, "(%%#.-#)(.*)", "%1" .. (left_p or " ") .. "%2")
    .. (right_p or " ")
end

--- Replace empty strings with a default substitution
---@param emp string|nil The potentially empty string
---@param sub string|nil Default replacement (defaults to "?")
---@return string The original string or the substitution
function M.sub_empty(emp, sub)
  sub = sub or "?"
  if emp == "" or emp == nil then
    return sub
  end
  return emp
end

--- Get current mode and its highlight group
---@return table Table with 'mode' and 'highlight' keys
function M.get_mode()
  local m = vim.api.nvim_get_mode().mode
  local mode = Mods[m]
  if not mode then
    return { mode = "UNKNOWN (" .. m .. ")", highlight = "%#StLineNormalMode#" }
  end
  return { mode = mode[1], highlight = "%#" .. mode[2] .. "#" }
end

--- Get current working directory name (last component)
---@return string The current directory name
function M.get_cwd()
  return fn.fnamemodify(fn.getcwd(), ":t")
end

--- Get file info with icon based on filetype
--- Uses nvim-web-devicons if available
---@return table Table with 'name' and 'icon' keys
function M.get_file_info()
  local icon = Statusline.icons.default_file
  local filename = (fn.expand("%") == "" and "") or fn.expand("%:t")

  if filename ~= "" then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")
    if devicons_present then
      local ft_icon = devicons.get_icon(filename)
      if ft_icon ~= nil then
        icon = ft_icon
      end
    end
  end
  return { name = filename, icon = icon }
end

--- Get current filetype
---@return string The buffer filetype
function M.get_filetype()
  return vim.bo.ft
end

--- Get current git branch from gitsigns
--- Requires gitsigns.nvim to be installed
---@return string The branch name or empty string
function M.get_branch()
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_ok then
    return ""
  end

  local status = vim.b.gitsigns_status_dict
  if not status or not status.head or status.head == "" then
    return ""
  end
  return status.head
end

--- Get git changes (added, changed, removed counts) from gitsigns
--- Requires gitsigns.nvim to be installed
---@return table|nil Table with 'added', 'changed', 'removed' keys or nil
function M.get_changes()
  local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_ok then
    return nil
  end

  local status = vim.b.gitsigns_status_dict
  if not status then
    return nil
  end

  return {
    added = status.added or 0,
    changed = status.changed or 0,
    removed = status.removed or 0,
  }
end

--- Get the attached LSP client name for the current buffer
---@return string The client name ("null-ls" or client name or empty string)
function M.get_lsp_client()
  if rawget(vim, "lsp") then
    local bufnr = vim.api.nvim_get_current_buf()
    for _, client in ipairs(vim.lsp.get_clients({ buffer = bufnr })) do
      return client.name
    end
  end
  return ""
end

--- Record an abnormal language-server exit for the statusline.
---@param name string
---@param code integer
---@param signal integer
function M.set_lsp_error(name, code, signal)
  if code == 0 or signal == 15 then
    return
  end
  lsp_errors[name] = { code = code, signal = signal, time = vim.uv.hrtime() }
end

--- Clear an LSP error after the server has successfully attached again.
---@param name string
function M.clear_lsp_error(name)
  lsp_errors[name] = nil
end

--- Return the most recently recorded LSP failure, if any.
---@return { name: string, code: integer, signal: integer }|nil
function M.get_lsp_error()
  local latest
  for name, error in pairs(lsp_errors) do
    if not latest or error.time > latest.time then
      latest =
        { name = name, code = error.code, signal = error.signal, time = error.time }
    end
  end
  return latest
end

--- Get diagnostic counts for the current buffer
---@return table Table with 'error', 'warn', 'hint', 'info' keys
function M.get_diagnostics()
  if not rawget(vim, "lsp") then
    return {}
  end
  return {
    error = M.count_severity(vim.diagnostic.severity.ERROR),
    warn = M.count_severity(vim.diagnostic.severity.WARN),
    hint = M.count_severity(vim.diagnostic.severity.HINT),
    info = M.count_severity(vim.diagnostic.severity.INFO),
  }
end

--- Get LSP progress message
--- Shows messages like "Loading", "Formatting", etc. with percentage
---@return table|string Table with 'message', 'title', 'percentage' keys or empty string
function M.get_lsp_message()
  if not rawget(vim, "lsp") or vim.lsp.status then
    return ""
  end
  local lsp = vim.lsp.util.get_progress_messages()[1]
  if not lsp then
    return ""
  end

  local msg = lsp.message or ""
  local percentage = lsp.percentage or 0
  local title = lsp.title or ""
  return { message = msg, title = title, percentage = percentage }
end

return M
