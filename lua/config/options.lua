-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.root_spec = {
  "lsp",
  ".git",
  function(buf)
    local bufname = require("lazyvim.util").root.bufpath(buf)
    return bufname and vim.fs.dirname(bufname)
  end,
}

vim.opt.conceallevel = 0
vim.opt.formatoptions = "jcrqlnt"
vim.opt.updatetime = 300 -- save swap file and trigger CursorHold
vim.opt.jumpoptions = "stack" -- jump list work like browser
vim.opt.listchars = {
  tab = "→ ",
  eol = "↵",
  trail = "·",
  extends = "↷",
  precedes = "↶",
}
vim.opt.breakindent = true -- indent wrapped lines to match line start
vim.opt.linebreak = true -- wrap long lines at 'breakat'
vim.opt.colorcolumn = "100" -- hightlight column
vim.opt.winblend = 10 -- floating blend
