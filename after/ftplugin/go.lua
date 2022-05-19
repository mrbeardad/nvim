require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "go" }, command = "golangci_lint" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "go" }, command = "gofmt" }
})
