require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "javascript" }, command = "eslint" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "javascript" }, command = "eslint" }
})
