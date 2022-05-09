require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "sh" }, command = "shellcheck" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "sh" }, command = "shfmt", args = { "-i", "2" } }
})
