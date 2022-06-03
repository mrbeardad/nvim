local M = {}

M.config = function()
	require("sidebar-nvim").setup({
		initial_width = 30,
		section_separator = {
			"",
			"──────────────────────────",
			"",
		},
		sections = { "files", "symbols", "todos" },
		files = {
			show_hidden = true,
		},
		todos = {
			icon = " ",
			ignored_paths = { "~" }, -- ignore certain paths, this will prevent huge folders like $HOME to hog Neovim with TODO searching
			initially_closed = false, -- whether the groups should be initially closed on start. You can manually open/close groups later.
		},
	})
end

return M
