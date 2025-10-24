local keymap = require("user.utils.keymap")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Plugins Manager
vim.keymap.set("n", "<Leader>p", "<Cmd>Lazy<CR>", { desc = "Plugins Manager" })

-- Buffers: switch
vim.keymap.set("n", "<Leader><Tab><Tab>", "<Cmd>try<Bar>b#<Bar>catch<Bar>endtry<CR>", { desc = "Switch Buffer" })

-- Buffers: save
vim.keymap.set({ "n", "x", "i" }, "<C-S>", keymap.save_file(false), { desc = "Save" })
vim.keymap.set({ "n", "x" }, "<Leader>bw", keymap.save_file(true), { desc = "Save Without Format" })

-- Windows: switch
vim.keymap.set("n", "<Tab>", keymap.switch_window(true), { desc = "Next Window" })
vim.keymap.set("n", "<S-Tab>", keymap.switch_window(), { desc = "Prev Window" })

-- Windows: zoom
vim.keymap.set("n", "<C-W>z", keymap.zoom_window, { desc = "Zoom Window" })

-- Windows: resize
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Tabs
vim.keymap.set("n", "<Leader>tt", "<Cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<Leader>t0", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<Leader>t$", "<Cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "<Leader>tn", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<Leader>tp", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<Leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })

-- Search: clear highlight
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR><Esc>", { desc = "Clear Highlight" })

-- Search: fix direction of n/N
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Search: simulate vscode search mode
vim.keymap.set("c", "<M-w>", keymap.toggle_search_pattern("w"), { desc = "Match Whole Word" })
vim.keymap.set("c", "<M-c>", keymap.toggle_search_pattern("c"), { desc = "Match Case" })
vim.keymap.set("c", "<M-r>", keymap.toggle_search_pattern("r"), { desc = "Toggle Very Magic" })

-- Scroll: horizontal
vim.keymap.set({ "n", "x", "i" }, "<M-f>", "<Cmd>normal zL<CR>", { desc = "Scroll Right" })
vim.keymap.set({ "n", "x", "i" }, "<M-b>", "<Cmd>normal zH<CR>", { desc = "Scroll Left" })

-- Motion: hjkl
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set("c", "<C-A>", "<C-B>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-A>", "<Home>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-E>", "<End>", { desc = "End Of Line" })

-- Motion: jump list
-- HACK: For historical reason, <Tab> and <C-I> have the same key sequence in most of terminals.
-- To distinguish them, you could map another key, say <M-I>, to <C-I> in neovim,
-- and then map ctrl+i to send <M-I> key sequence in your terminal setting.
-- For more info `:h tui-modifyOtherKeys` and https://invisible-island.net/xterm/modified-keys.html
vim.keymap.set({ "i", "c", "n", "v" }, "<M-`>", "<C-`>", { desc = "<C-`>", remap = true })
vim.keymap.set({ "i", "c", "n", "v" }, "<M-I>", "<C-I>", { desc = "<C-I>", remap = true })
vim.keymap.set({ "i", "c", "n", "v" }, "<M-J>", "<C-S-J>", { desc = "<C-S-J>", remap = true })

-- Motion: go to diagnostic
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

-- Operation: delete or change without register
vim.keymap.set({ "n", "x" }, "<M-d>", '"_d', { desc = "Delete Without Register" })
vim.keymap.set({ "n", "x" }, "<M-c>", '"_c', { desc = "Change Without Register" })

-- Operation: better indenting
vim.keymap.set("n", "<", "<<", { desc = "Deindent" })
vim.keymap.set("n", ">", ">>", { desc = "Indent" })
vim.keymap.set("x", "<", "<gv", { desc = "Deindent" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent" })

-- Operation: move lines
vim.keymap.set("i", "<M-j>", "<Cmd>m .+1<Bar>normal ==<CR>", { desc = "Move Down" })
vim.keymap.set("i", "<M-k>", "<Cmd>m .-2<Bar>normal ==<CR>", { desc = "Move Up" })
vim.keymap.set("n", "<M-j>", "<Cmd>m .+1<CR>==", { desc = "Move Down" })
vim.keymap.set("n", "<M-k>", "<Cmd>m .-2<CR>==", { desc = "Move Up" })
vim.keymap.set("x", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("x", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- Operation: add empty lines
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

-- Operation: insert/cmdline mode
vim.keymap.set("c", "<C-D>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<C-D>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<M-d>", '<C-G>u<Cmd>normal! "_dw<CR>', { desc = "Delete Right Word" })
vim.keymap.set("c", "<C-K>", function()
  local text = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  if text and col - 1 < #text then
    vim.fn.setcmdline(text:sub(1, col - 1))
  end
end)
vim.keymap.set("i", "<C-K>", '<C-G>u<Cmd>normal! "_d$<CR><Right>', { desc = "Delete All Right" })
vim.keymap.set("i", "<C-J>", "<C-G>u<End><CR>", { desc = "New Line" }) -- <C-G>u is required here since <End> does not break undo here

-- Operation: yank and paste
vim.keymap.set("x", "<C-C>", "y", { desc = "Yank" })
vim.keymap.set("i", "<C-V>", "<C-G>u<C-R><C-P>+", { desc = "Paste Last Yanked" })
vim.keymap.set("c", "<C-V>", "<C-R>+", { desc = "Paste Last Yanked" })

-- UI: quit
vim.keymap.set("n", "<Leader>qq", "<Cmd>qa<CR>", { desc = "Quit All" })

-- UI: toggle options
vim.keymap.set(
  "n",
  "<Leader>ub",
  '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>',
  { desc = "Toggle 'background'" }
)
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
vim.keymap.set("n", "<M-z>", "<Cmd>setlocal wrap!<CR>", { desc = "Toggle 'wrap'" })

-- UI: floating terminal
vim.keymap.set("n", "<M-`>", keymap.open_term, { desc = "Terminal" })
vim.keymap.set("t", "<M-`>", keymap.open_term, { desc = "Terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", { desc = "Enter Normal Mode" })
vim.keymap.set("n", "<Leader>gg", function()
  keymap.open_term("lazygit")
end, { desc = "Lazygit" })
