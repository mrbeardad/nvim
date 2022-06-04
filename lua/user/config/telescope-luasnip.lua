local M = {}

M.config = function()
	require("telescope").load_extension("luasnip")
	vim.api.nvim_set_keymap("n", "<M-i>", "<CMD>Telescope luasnip<CR>", { noremap = true })
	vim.api.nvim_set_keymap("i", "<M-i>", "<CMD>Telescope luasnip<CR>", { noremap = true })
end

return M
