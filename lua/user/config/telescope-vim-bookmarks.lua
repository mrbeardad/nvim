local M = {}

M.config = function()
	require("telescope").load_extension("vim_bookmarks")
	vim.api.nvim_set_keymap(
		"n",
		"ml",
		'<CMD>lua require("telescope").extensions.vim_bookmarks.current_file()<CR>',
		{ noremap = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"mL",
		'<CMD>lua require("telescope").extensions.vim_bookmarks.all()<CR>',
		{ noremap = true }
	)
end

return M
