local M = {}

M.config = function()
	require("spectre").setup({
		line_sep_start = "╭─────────────────────────────────────────────────────────",
		result_padding = "│  ",
		line_sep = "╰─────────────────────────────────────────────────────────",
		mapping = {
			["run_replace"] = {
				map = "<M-C-CR>",
				cmd = "<CMD>lua require('spectre.actions').run_replace()<CR>",
				desc = "replace all",
			},
			["toggle_ignore_case"] = {
				map = "<M-c>",
				cmd = "<CMD>lua require('spectre').change_options('ignore-case')<CR>",
				desc = "toggle ignore case",
			},
			["send_to_qf"] = {
				map = "\\q",
				cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
				desc = "send all item to quickfix",
			},
			["replace_cmd"] = {
				map = "\\c",
				cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
				desc = "input replace vim command",
			},
			["show_option_menu"] = {
				map = "\\o",
				cmd = "<cmd>lua require('spectre').show_options()<CR>",
				desc = "show option",
			},
			["change_view_mode"] = {
				map = "\\v",
				cmd = "<cmd>lua require('spectre').change_view()<CR>",
				desc = "change result view mode",
			},
		},
	})
	vim.api.nvim_set_keymap(
		"n",
		"<C-H>",
		"<CMD>lua require('spectre').open_visual({select_word=true,path='/' .. vim.fn.fnameescape(vim.fn.expand('%:p:.'))})<CR>",
		{ noremap = true }
	)
	vim.api.nvim_set_keymap(
		"v",
		"<C-H>",
		":lua require('spectre').open_visual({path='/' .. vim.fn.fnameescape(vim.fn.expand('%:p:.'))})<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<C-S-H>",
		"<CMD>lua require('spectre').open_visual({select_word=true})<CR>",
		{ noremap = true }
	)
	vim.api.nvim_set_keymap(
		"v",
		"<C-S-H>",
		":lua require('spectre').open_visual()<CR>",
		{ noremap = true, silent = true }
	)
end

return M
