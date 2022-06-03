local M = {}

M.config = function()
	require("lsp_signature").setup({
		hint_prefix = " ",
	})
end

return M
