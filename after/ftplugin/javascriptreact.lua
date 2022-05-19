require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "javascriptreact" }, command = "eslint" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "javascriptreact" }, command = "eslint" }
})
