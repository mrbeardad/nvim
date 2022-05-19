require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "css" }, command = "stylelint" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "css" }, command = "prettier" }
})
