local M = {}

M.config = function()
	vim.list_extend(lvim.builtin.cmp.sources, { { name = "zsh" } })
	require("cmp_zsh").setup({
		filetype = { "sh", "zsh" },
	})
end

return M
