-- Statusline configuration defaults

local defaults = {
  -- Theme to use ('vscode' is the default theme)
  theme = "vscode",

  -- Minimum terminal width to show cursor position
  position_min_width = 140,

  -- Minimum terminal width to show git changes
  git_changes_min_width = 120,

  -- Minimum terminal width to show LSP progress
  LSP_progress_min_width = 120,

  -- Optional: truncate LSP progress message to this length
  lsprogress_len = nil,

  -- Icons for various statusline elements
  icons = {
    modified = "",
    mode = "",
    default_file = "󰈚",
    git_branch = "",
    cwd = "󰉖",
    git_changes = {
      added = "",
      changed = "",
      removed = "",
    },
    lsp = "󰄭",
    diagnostics = {
      error = "󰅚",
      warn = "",
      hint = "󰛩",
      info = "",
    },
    -- Spinner animation frames for LSP progress
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
}

-- Initialize global Statusline table if not already present
if not Statusline then
  Statusline = {
    opts = {},
  }
end

return {
  defaults = defaults,
}
