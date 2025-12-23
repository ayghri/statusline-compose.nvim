-- Modular statusline components
-- Ready-to-use formatted components that combine data retrieval with rendering
-- Each component returns a formatted string ready for display in the statusline

local C = require("statusline-compose.core.common")
local M = {}

--- Mode component: Display current vim mode with icon and highlight
---@return string The formatted mode string
function M.mode()
  local m = C.get_mode()
  return C.join(" ", { m.highlight .. Statusline.icons.mode, m.mode })
end

--- File info component: Display filename with filetype icon
---@return string The formatted file info string
function M.file_info()
  local info = C.get_file_info()
  return C.join(" ", {
    "%#StLineFileInfo# " .. info.icon,
    C.sub_empty(info.name)
      .. "%#StLinePosSep#"
      .. ((vim.bo.modified and " " .. Statusline.icons.modified) or ""),
  })
end

--- Filetype component: Display current file's type
---@return string The formatted filetype string
function M.filetype()
  return C.join(" ", { "%#StLineFileType#", C.sub_empty(C.get_filetype()) })
end

--- Git branch component: Display current git branch name
--- Requires gitsigns.nvim
---@return string The formatted git branch string or empty string if not in a git repo
function M.git_branch()
  local branch = C.get_branch()
  if branch ~= "" then
    return C.join(
      " ",
      { "%#StLineGitBranch#", Statusline.git_branch_icon, branch }
    )
  end
  return ""
end

--- Git changes component: Display git changes (added, modified, removed counts)
--- Requires gitsigns.nvim. Only shown when terminal width exceeds git_changes_min_width
---@return string The formatted git changes string or empty string
function M.git_changes()
  if vim.o.columns < Statusline.git_changes_min_width then
    return ""
  end
  local changes = C.get_changes()
  if not changes then
    return ""
  end
  local highlights = {
    added = "%#StLineLSPInfo#",
    changed = "%#StLineLSPWarning#",
    removed = "%#StLineLSPError#",
  }
  local icons = Statusline.icons.git_changes
  local result = {}
  for k, v in pairs(changes) do
    if v > 0 then
      table.insert(result, highlights[k] .. icons[k])
      table.insert(result, v)
    end
  end
  return C.join(" ", result)
end

--- LSP diagnostics component: Display error, warning, hint, and info counts
--- Only shown when terminal width allows (columns > 0)
---@return string The formatted diagnostics string or empty string
function M.lsp_diagnostics()
  if vim.o.columns <= 0 then
    return ""
  end
  local diags = C.get_diagnostics()
  local icons = Statusline.icons.diagnostics
  local diagnostics = C.join(" ", {
    "%#StLineLspError#" .. icons.error,
    C.sub_empty(diags.error),
  })

  diagnostics = C.join(" ", {
    diagnostics,
    "%#StLineLspWarning#" .. icons.warn,
    C.sub_empty(diags.warn),
  })

  if diags.hint ~= nil and diags.hint > 0 then
    diagnostics = C.join(
      " ",
      { diagnostics, "%#StLineLspHints#" .. icons.hint, diags.hint }
    )
  end

  if diags.info ~= nil and diags.info > 0 then
    diagnostics = C.join(
      " ",
      { diagnostics, "%#StLineLspInfo#" .. icons.info, diags.info }
    )
  end

  return diagnostics
end

--- LSP progress component: Display LSP server progress with animated spinner
--- Only shown when terminal width exceeds LSP_progress_min_width
---@return string The formatted LSP progress string or empty string
function M.lsp_progress()
  if vim.o.columns < Statusline.LSP_progress_min_width then
    return ""
  end
  local progress = C.get_lsp_message()
  if progress == "" then
    return ""
  end
  local spinners = Statusline.icons.spinners
  local content = string.format(
    " %%<%s %s %s (%s%%%%) ",
    spinners[C.get_cyclic_counter(#spinners) + 1],
    progress.title,
    progress.message,
    progress.percentage
  )
  if vim.g.lsprogress_len then
    content = string.sub(content, 1, vim.g.lsprogress_len)
  end

  return "%#StLineLspProgress#" .. content
end

--- LSP status component: Display connected LSP client name
--- Shows full name on wide terminals, just "LSP" on narrow terminals
---@return string The formatted LSP status string or empty string if no client connected
function M.lsp_status()
  local client = C.get_lsp_client()
  if client == "" then
    return ""
  end
  -- Show "null-ls" as "LSP"
  if client == "null-ls" then
    client = "LSP"
  end
  if vim.o.columns > 100 then
    return C.join(" ", { "%#StLineLspStatus#", Statusline.icons.lsp, client })
  end
  return C.join(" ", { "%#StLineLspStatus#", Statusline.icons.lsp, "LSP" })
end

--- Cursor position component: Display line number, column, and optionally totals
--- Only shown when terminal width exceeds position_min_width
---@param show_total boolean Show total lines/columns (default: true)
---   - true:  "Ln 10/100, Cl 5/80" (shows current and total)
---   - false: "Ln 10, Cl 5" (shows only current position)
---@return string The formatted cursor position string or empty string
function M.cursor_position(show_total)
  if vim.o.columns < Statusline.position_min_width then
    return ""
  end

  -- Default to true if not specified
  show_total = (show_total == nil) and true or show_total
  local max_col = #vim.api.nvim_get_current_line()

  if show_total then
    -- Show current and total: "Ln 10/100, Cl 5/80"
    return "%#StLinePosText#Ln "
      .. "%l"
      .. "%#StLinePosSep#/%#StLinePosText#"
      .. "%L, Cl %c"
      .. "%#StLinePosSep#/%#StLinePosText#"
      .. max_col
  else
    -- Show only current position: "Ln 10, Cl 5"
    return "%#StLinePosText#Ln %l, Cl %c"
  end
end

--- File encoding component: Display current file encoding (e.g., "UTF-8")
---@return string The formatted file encoding string or empty string if encoding is empty
function M.file_encoding()
  local encoding = string.upper(vim.bo.fileencoding)
  if encoding == "" then
    return ""
  end
  return C.join(" ", { "%#StLineEncode#", encoding })
end

--- Working directory component: Display current working directory name
--- Only shown on wide terminals (> 85 columns)
---@return string The formatted working directory string or empty string
function M.cwd()
  if vim.o.columns > 85 then
    return C.join(" ", { "%#StLineCwd#", Statusline.icons.cwd, C.get_cwd() })
  end
  return ""
end

return M
