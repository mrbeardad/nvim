local keymap = require("user.utils.keymap")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- plugins manager
vim.keymap.set("n", "<Leader>pp", "<Cmd>Lazy<CR>", { desc = "Plugins Manager" })

-- buffers: switch
vim.keymap.set("n", "<Leader><Tab><Tab>", "<Cmd>try<Bar>b#<Bar>catch<Bar>endtry<CR>", { desc = "Switch Buffer" })

-- buffers: save
vim.keymap.set("n", "<C-s>", "<Cmd>silent! update<Bar>redraw<CR>", { desc = "Save" })
vim.keymap.set({ "i", "x" }, "<C-s>", "<Esc><Cmd>silent! update<Bar>redraw<CR>", { desc = "Save" })
vim.keymap.set("n", "<Leader>bw", "<Cmd>noautocmd w<CR>", { desc = "Save Without Format" })

-- windows: switch
vim.keymap.set("n", "<Tab>", keymap.switch_window(true), { desc = "Next Window" })
vim.keymap.set("n", "<S-Tab>", keymap.switch_window(), { desc = "Prev Window" })

-- windows: zoom
vim.keymap.set("n", "<C-w>z", keymap.zoom_window, { desc = "Zoom Window" })

-- windows: resize
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- tabs
vim.keymap.set("n", "<Leader>tt", "<Cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<Leader>t0", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<Leader>t$", "<Cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "<Leader>tn", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<Leader>tp", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<Leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })

-- search: fix direction of n/N
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- search: simulate vscode search mode
vim.keymap.set("c", "<A-w>", keymap.toggle_search_pattern("w"), { desc = "Match Whole Word" })
vim.keymap.set("c", "<A-c>", keymap.toggle_search_pattern("c"), { desc = "Match Case" })
vim.keymap.set("c", "<A-r>", keymap.toggle_search_pattern("r"), { desc = "Toggle Very Magic" })

-- motions
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set("c", "<C-a>", "<C-b>", { silent = false, desc = "Start Of Line" })
vim.keymap.set("c", "<M-h>", "<Left>", { silent = false, desc = "Left" })
vim.keymap.set("c", "<M-l>", "<Right>", { silent = false, desc = "Right" })
vim.keymap.set("i", "<C-a>", "<C-g>u<Cmd>normal! ^<CR>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End Of Line" })
vim.keymap.set("i", "<C-l>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<M-h>", "<Left>", { remap = true, desc = "Left" })
vim.keymap.set("i", "<M-j>", "<Down>", { remap = true, desc = "Down" })
vim.keymap.set("i", "<M-k>", "<Up>", { remap = true, desc = "Up" })
vim.keymap.set("i", "<M-l>", "<Right>", { remap = true, desc = "Right" })
vim.keymap.set("t", "<M-h>", "<Left>", { desc = "Left" })
vim.keymap.set("t", "<M-j>", "<Down>", { desc = "Down" })
vim.keymap.set("t", "<M-k>", "<Up>", { desc = "Up" })
vim.keymap.set("t", "<M-l>", "<Right>", { desc = "Right" })

-- HACK: For historical reason, <Tab> and <C-i> have the same key sequence in most of terminals.
-- To distinguish them, you could map another key, say <A-I>, to <C-i> in neovim,
-- and then map ctrl+i to send <A-I> key sequence in your terminal setting.
-- For more info `:h tui-modifyOtherKeys` and https://invisible-island.net/xterm/modified-keys.html
vim.keymap.set({ "i", "c", "n", "x", "s" }, "<M-I>", "<C-i>", { desc = "<C-i>" })

-- edit: better indenting
vim.keymap.set("n", "<", "<<", { desc = "Deindent" })
vim.keymap.set("n", ">", ">>", { desc = "Indent" })
vim.keymap.set("x", "<", "<gv", { desc = "Deindent" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent" })

-- edit: move lines
vim.keymap.set("i", "<A-j>", "<Cmd>m .+1<Bar>normal ==<CR>", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<Cmd>m .-2<Bar>normal ==<CR>", { desc = "Move Up" })
vim.keymap.set("n", "<A-j>", "<Cmd>m .+1<CR>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<Cmd>m .-2<CR>==", { desc = "Move Up" })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- edit: add empty lines
vim.keymap.set(
  "n",
  "]<Space>",
  "v:lua.require'user.utils.keymap'.put_empty_line(v:false)",
  { expr = true, desc = "Put Empty Line Below" }
)
vim.keymap.set(
  "n",
  "[<Space>",
  "v:lua.require'user.utils.keymap'.put_empty_line(v:true)",
  { expr = true, desc = "Put Empty Line Above" }
)

-- edit: insert mode
-- Add undo break-points
vim.keymap.set("c", "<C-k>", function()
  local text = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  if text and col - 1 < #text then
    vim.fn.setcmdline(text:sub(1, col - 1))
  end
end)
-- vim.keymap.set("i", ",", ",<C-g>u")
-- vim.keymap.set("i", ".", ".<C-g>u")
-- vim.keymap.set("i", ";", ";<C-g>u")
vim.keymap.set("i", "<C-j>", "<C-g>u<End><CR>")
vim.keymap.set("i", "<C-k>", '<C-g>u<Cmd>normal! "_d$<CR><Right>')
vim.keymap.set("i", "<C-z>", "<Cmd>undo<CR>")

-- register: yank and paste
vim.keymap.set("n", "<Leader>by", [[<Cmd>%y +<CR>]], { desc = "Yank Whole Buffer To Clip" })
vim.keymap.set("n", "<Leader>bp", [[<Cmd>%d<CR>"+P]], { desc = "Paste Clip Override Whole Buffer" })
vim.keymap.set("x", "<C-c>", [["+y]])
vim.keymap.set("i", "<C-v>", "<C-g>u<C-r><C-p>+")
vim.keymap.set("c", "<C-v>", "<C-r>+")

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
    vim.diagnostic.open_float()
  end
end
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

vim.keymap.set("n", "<Leader>qq", "<Cmd>qa<CR>", { desc = "Quit All" })

-- stylua: ignore start

-- Toggle without feedback
vim.keymap.set("n", "<Leader>ub", '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>', { desc = "Toggle 'background'" })
vim.keymap.set("n", "<Leader>uc", "<Cmd>setlocal cursorline!<CR>", { desc = "Toggle 'cursorline'" })
vim.keymap.set("n", "<Leader>uC", "<Cmd>setlocal cursorcolumn!<CR>", { desc = "Toggle 'cursorcolumn'" })
vim.keymap.set("n", "<Leader>ud", "<Cmd>lua MiniBasics.toggle_diagnostic()<CR>", { desc = "Toggle diagnostic" })
vim.keymap.set("n", "<Leader>uh", "<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>", { desc = "Toggle search highlight" })
vim.keymap.set("n", "<Leader>ui", "<Cmd>setlocal ignorecase!<CR>", { desc = "Toggle 'ignorecase'" })
vim.keymap.set("n", "<Leader>ul", "<Cmd>setlocal list!<CR>", { desc = "Toggle 'list'" })
vim.keymap.set("n", "<Leader>un", "<Cmd>setlocal number!<CR>", { desc = "Toggle 'number'" })
vim.keymap.set("n", "<Leader>ur", "<Cmd>setlocal relativenumber!<CR>", { desc = "Toggle 'relativenumber'" })
vim.keymap.set("n", "<Leader>us", "<Cmd>setlocal spell!<CR>", { desc = "Toggle 'spell'" })
vim.keymap.set("n", "<Leader>uw", "<Cmd>setlocal wrap!<CR>", { desc = "Toggle 'wrap'" })

-- lazygit
--vim.keymap.set("n", "<Leader>gg", function() Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (root dir)" })
--vim.keymap.set("n", "<Leader>gG", function() Util.terminal({ "lazygit" }, {esc_esc = false, ctrl_hjkl = false}) end, { desc = "Lazygit (cwd)" })

-- floating terminal
-- local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
-- vim.keymap.set("n", "<Leader>ft", lazyterm, { desc = "Terminal (root dir)" })
-- vim.keymap.set("n", "<Leader>fT", function() Util.terminal() end, { desc = "Terminal (cwd)" })
-- vim.keymap.set("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
-- vim.keymap.set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
-- vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to left window" })
-- vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to lower window" })
-- vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to upper window" })
-- vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to right window" })
-- vim.keymap.set("t", "<C-/>", "<Cmd>close<CR>", { desc = "Hide Terminal" })
-- vim.keymap.set("t", "<c-_>", "<Cmd>close<CR>", { desc = "which_key_ignore" })
