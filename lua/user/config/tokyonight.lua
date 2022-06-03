local M = {}

M.config = function()
	vim.g.tokyonight_dev = true
	vim.g.tokyonight_style = "storm"
	vim.g.tokyonight_sidebars = {
		"qf",
		"vista_kind",
		"terminal",
		"packer",
		"spectre_panel",
		"NeogitStatus",
		"help",
	}
	vim.g.tokyonight_cterm_colors = false
	vim.g.tokyonight_terminal_colors = true
	vim.g.tokyonight_italic_comments = true
	vim.g.tokyonight_italic_keywords = true
	vim.g.tokyonight_italic_functions = true
	vim.g.tokyonight_italic_variables = false
	vim.g.tokyonight_transparent = lvim.transparent_window
	vim.g.tokyonight_dark_sidebar = true
	vim.g.tokyonight_dim_inactive = true
	vim.g.tokyonight_global_status = true
	vim.g.tokyonight_dark_float = true
	vim.g.tokyonight_colors = {
		git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" },
	}
end

return M
