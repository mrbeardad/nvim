local M = {}

M.config = function()
	require("telescope").load_extension("live_grep_raw")
	vim.api.nvim_set_keymap("n", "<C-S-F>", "<CMD>Telescope live_grep_raw<CR>", { noremap = true })
end

return M
