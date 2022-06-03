local M = {}

M.config = function()
	-- if you don't want all the parsers change this to a table of the ones you want
	lvim.builtin.treesitter.matchup.enable = true
	lvim.builtin.treesitter.textobjects.select = {
		enable = true,
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		keymaps = {
			-- You can use the capture groups defined in textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	}
	lvim.builtin.treesitter.textobjects.move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = "@class.outer",
		},
		goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		},
	}
	lvim.builtin.treesitter.highlight.enabled = true
	lvim.builtin.treesitter.rainbow.enable = true
	lvim.builtin.treesitter.ensure_installed = {
		"bash",
		"vim",
		"lua",
		"c",
		"cpp",
		"cmake",
		"go",
		"python",
		"javascript",
		"typescript",
		"tsx",
		"html",
		"css",
		"markdown",
		"json",
		"yaml",
	}
end

return M
