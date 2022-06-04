require("lvim.lsp.null-ls.linters").setup({
	{ filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, command = "eslint" },
})
require("lvim.lsp.null-ls.formatters").setup({
	{ filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, command = "eslint" },
})
