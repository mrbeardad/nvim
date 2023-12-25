-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.g.vscode then
  return
end

vim.g.root_spec = {
  "lsp",
  ".git",
  function(buf) -- Fallback to buffer dirctory
    local bufname = require("lazyvim.util").root.bufpath(buf)
    return bufname and vim.fs.dirname(bufname)
  end,
}

vim.opt.updatetime = 300 -- Save swap file and trigger CursorHold
vim.opt.jumpoptions = "stack" -- Jump list work like browser
vim.opt.formatoptions = "jcrqlnt"
vim.opt.conceallevel = 0 -- Don't hide text
vim.opt.listchars = {
  tab = "→ ",
  eol = "↵",
  trail = "·",
  extends = "↷",
  precedes = "↶",
}
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.linebreak = true -- Wrap long lines at 'breakat'
vim.opt.colorcolumn = "100" -- Hightlight column
vim.opt.winblend = 10 -- Floating blend
vim.opt.cmdheight = 0 -- Avoid blink on startup since noice will set it to 0
