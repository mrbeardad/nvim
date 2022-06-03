local M = {}

M.config = function()
	vim.api.nvim_set_keymap("n", "<C-S-L>", "<Plug>(VM-Select-All)", {})
	vim.api.nvim_set_keymap("v", "<C-S-L>", "<Plug>(VM-Visual-All)", {})
	vim.api.nvim_set_keymap("n", "ma", "<Plug>(VM-Add-Cursor-At-Pos)", {})
	vim.api.nvim_set_keymap("v", "ma", "<Plug>(VM-Visual-Add)", {})
end

return M
