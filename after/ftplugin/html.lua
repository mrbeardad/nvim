require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "html" }, command = "tidy" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "html" }, command = "prettier" }
})
