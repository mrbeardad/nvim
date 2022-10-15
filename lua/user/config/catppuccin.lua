local M = {}

M.config = function()
	vim.g.catppuccin_flavour = "macchiato"
	local catppuccin = require("catppuccin")
	catppuccin.setup({
		transparent_background = lvim.transparent_window,
		term_colors = true,
		dim_inactive = {
			enabled = true,
		},
		styles = {
			comments = { "italic" },
			strings = { "italic" },
			keywords = { "italic" },
			functions = { "italic" },
			numbers = { "italic" },
		},
		integrations = {
			lsp_trouble = true,
			nvimtree = {
				transparent_panel = lvim.transparent_window,
			},
			which_key = true,
			ts_rainbow = true,
			hop = true,
		},
	})
end

return M
