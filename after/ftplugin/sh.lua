require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "sh" }, command = "shellcheck" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "sh" }, command = "shfmt", extra_args = { "-i", "2" } }
})
