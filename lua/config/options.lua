-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.vscode then
  vim.notify = require("vscode").notify
  vim.g.clipboard = vim.g.vscode_clipboard
  return
end

vim.g.autoformat = true
vim.opt.cmdheight = 0

vim.opt.listchars = {
  tab = "→ ",
  eol = "↵",
  trail = "·",
  extends = "↷",
  precedes = "↶",
}
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
