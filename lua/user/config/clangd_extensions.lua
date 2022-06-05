local M = {}

M.config = function()
	require("clangd_extensions").setup({
		server = {
			cmd = { "clangd", "--clang-tidy", "--enable-config", "--function-arg-placeholders=0" },
			on_attach = function(client, bufnr)
				require("lvim.lsp").common_on_attach(client, bufnr)
				-- require("lsp_signature").on_attach(require("user.config.lsp_signature").config_table)
				vim.keymap.set("n", "<M-o>", "<CMD>ClangdSwitchSourceHeader<CR>", { noremap = true, buffer = bufnr })
			end,
			on_init = require("lvim.lsp").common_on_init,
			capabilities = require("lvim.lsp").common_capabilities(),
		},
		extensions = {
			inlay_hints = {
				other_hints_prefix = " ",
			},
		},
	})
end

return M
