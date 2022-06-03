local M = {}

M.config = function()
	require("nvim-lastplace").setup({
		lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
		lastplace_ignore_filetype = { "gitcommit", "gitrebase" },
		lastplace_open_folds = true,
	})
end

return M
