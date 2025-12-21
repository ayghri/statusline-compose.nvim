-- Vim mode definitions and their associated display names and highlight groups
-- Each mode is mapped to: { display_name, highlight_group_name }

return {
	-- Normal mode variants
	["n"] = { "NORMAL", "StLineNormalMode" },
	["no"] = { "NORMAL (no)", "StLineNormalMode" },
	["nov"] = { "NORMAL (nov)", "StLineNormalMode" },
	["noV"] = { "NORMAL (noV)", "StLineNormalMode" },
	["noCTRL-V"] = { "NORMAL", "StLineNormalMode" },
	["niI"] = { "NORMAL i", "StLineNormalMode" },
	["niR"] = { "NORMAL r", "StLineNormalMode" },
	["niV"] = { "NORMAL v", "StLineNormalMode" },
	["nt"] = { "NTERMINAL", "StLineNTerminalMode" },
	["ntT"] = { "NTERMINAL (ntT)", "StLineNTerminalMode" },

	-- Visual modes
	["v"] = { "VISUAL", "StLineVisualMode" },
	["vs"] = { "V-CHAR (Ctrl O)", "StLineVisualMode" },
	["V"] = { "V-LINE", "StLineVisualMode" },
	["Vs"] = { "V-LINE", "StLineVisualMode" },
	[""] = { "V-BLOCK", "StLineVisualMode" },

	-- Insert mode variants
	["i"] = { "INSERT", "StLineInsertMode" },
	["ic"] = { "INSERT (completion)", "StLineInsertMode" },
	["ix"] = { "INSERT completion", "StLineInsertMode" },

	-- Terminal mode
	["t"] = { "TERMINAL", "StLineTerminalMode" },

	-- Replace modes
	["R"] = { "REPLACE", "StLineReplaceMode" },
	["Rc"] = { "REPLACE (Rc)", "StLineReplaceMode" },
	["Rx"] = { "REPLACEa (Rx)", "StLineReplaceMode" },
	["Rv"] = { "V-REPLACE", "StLineReplaceMode" },
	["Rvc"] = { "V-REPLACE (Rvc)", "StLineReplaceMode" },
	["Rvx"] = { "V-REPLACE (Rvx)", "StLineReplaceMode" },

	-- Select modes
	["s"] = { "SELECT", "StLineSelectMode" },
	["S"] = { "S-LINE", "StLineSelectMode" },

	-- Command and confirm modes
	["c"] = { "COMMAND", "StLineCommandMode" },
	["cv"] = { "COMMAND", "StLineCommandMode" },
	["ce"] = { "COMMAND", "StLineCommandMode" },
	["r"] = { "PROMPT", "StLineConfirmMode" },
	["rm"] = { "MORE", "StLineConfirmMode" },
	["r?"] = { "CONFIRM", "StLineConfirmMode" },
	["x"] = { "CONFIRM", "StLineConfirmMode" },
	["!"] = { "SHELL", "StLineTerminalMode" },
}
