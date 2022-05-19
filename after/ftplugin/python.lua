require "lvim.lsp.null-ls.linters".setup({
  { filetypes = { "python" }, command = "pylint" },
  { filetypes = { "python" }, command = "flake8" }
})
require "lvim.lsp.null-ls.formatters".setup({
  { filetypes = { "python" }, command = "yapf" }
})
