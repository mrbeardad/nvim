local M = {}

M.config = function()
	require("clangd_extensions").setup({
		server = {
			cmd = { "clangd", "--clang-tidy", "--enable-config" },
			on_attach = require("lvim.lsp").common_on_attach,
			on_init = require("lvim.lsp").common_on_init,
			on_exit = require("lvim.lsp").common_on_exit,
			capabilities = require("lvim.lsp").common_capabilities(),
		},
	})
	vim.api.nvim_create_autocmd(
		"FileType",
		{ pattern = "c,cpp", command = [[nnoremap <buffer><M-o> <CMD>ClangdSwitchSourceHeader<CR>]] }
	)
end

return M
