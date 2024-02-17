-- Editor
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.autowrite = true -- Enable auto write
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undolevels = 10000 -- Increase undolevels since lots of undo breaks are set in insert mode
vim.opt.updatetime = 300 -- Save swap file and trigger CursorHold
vim.opt.timeoutlen = 300 -- Wait for a mapped sequence to complete.
vim.opt.shortmess = "oOtTWIcCFS"

-- Search
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Don't ignore case with capitals

-- Scroll
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context

-- Motions
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.jumpoptions = "stack" -- Jumplist works like browser

-- Operation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shiftround = true -- Round indent
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.formatoptions = "tcrqjnl"
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- UI: inside window
vim.opt.list = true -- Show some invisible characters
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
  diff = "╱",
  eob = " ",
}
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.wrap = false -- Disable line wrap
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.linebreak = true -- Wrap long lines at 'breakat'
vim.opt.number = true -- Show line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.colorcolumn = "100" -- Highlight the column

-- UI: window
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.winblend = 10 -- Floating blend
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitbelow = true -- Put new windows below current

-- UI: others
vim.opt.mouse = "a" -- Enable mouse in all mode
vim.opt.showmode = false -- Show mode in statusline
vim.opt.termguicolors = true -- True color support
vim.opt.statuscolumn = [[%!v:lua.require'user.utils.ui'.statuscolumn()]]
