return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keywords = {
			FIX = {
				icon = "B", -- icon used for the sign, and in search results
				color = "error", -- can be a hex color, or a named color (see below)
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
				-- signs = false, -- configure signs for some keywords individually
			},
			TODO = { icon = "T", color = "info" },
			HACK = { icon = "W", color = "warning" },
			WARN = { icon = "W", color = "warning", alt = { "WARNING" } },
			NOTE = { icon = "N", color = "hint", alt = { "INFO" } },
			TEST = { icon = "I", color = "test", alt = { "TESTING" } },

		},
		colors = {
			error = { "DiagnosticError", "ErrorMsg", "#0000FF" },
			warning = { "DiagnosticWarn", "WarningMsg", "#00FF00" },
			info = { "DiagnosticInfo", "#FF00FF" },
			hint = { "DiagnosticHint", "#FF0000" },
			default = { "Identifier", "#FFFFFF" },
			test = { "Identifier", "#AAAAAA" },
		},
	}
}
