-- editor
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.autowrite = true -- enable auto write
vim.opt.undofile = true -- enable persistent undo
vim.opt.updatetime = 300 -- save swap file and trigger CursorHold
vim.opt.timeoutlen = 300 -- wait for a mapped sequence to complete.
vim.opt.shortmess = "oOtTWIcCFS"

-- scroll
vim.opt.scrolloff = 4 -- lines of context
vim.opt.sidescrolloff = 8 -- columns of context

-- search
vim.opt.ignorecase = true -- ignore case
vim.opt.smartcase = true -- don't ignore case with capitals

-- motions
vim.opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode

-- register
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard

-- edit
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.tabstop = 2 -- number of spaces tabs count for
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.shiftround = true -- round indent
vim.opt.smartindent = true -- insert indents automatically
vim.opt.formatoptions = "tcroqjnl"

-- ui: inside window
vim.opt.list = true -- show some invisible characters (tabs...
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
vim.opt.cursorline = true -- enable highlighting of the current line
vim.opt.wrap = false -- disable line wrap
vim.opt.breakindent = true -- indent wrapped lines to match line start
vim.opt.linebreak = true -- wrap long lines at 'breakat'
vim.opt.number = true -- show line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
vim.opt.colorcolumn = "100"

-- ui: window
vim.opt.winminwidth = 5 -- minimum window width
vim.opt.winblend = 10 -- floating blend
vim.opt.pumblend = 10 -- popup blend
vim.opt.pumheight = 10 -- maximum number of entries in a popup
vim.opt.splitright = true -- put new windows right of current
vim.opt.splitbelow = true -- put new windows below current
vim.opt.splitkeep = "screen"

-- ui: global
vim.opt.mouse = "a" -- enable mouse in all mode
vim.opt.laststatus = 3 -- global statusline
vim.opt.showmode = false -- show mode in statusline
vim.opt.termguicolors = true -- true color support
