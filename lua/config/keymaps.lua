-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local lazyutil = require("lazyvim.util")
local keymaps = require("user.keymaps")

-- Change LazyVim builtin keymaps
vim.keymap.set("i", "<A-j>", "<Cmd>m .+1<Bar>normal ==<CR>", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<Cmd>m .-2<Bar>normal ==<CR>", { desc = "Move Up" })

vim.keymap.del("i", ",")
vim.keymap.del("i", ".")
vim.keymap.del("i", ";")

vim.keymap.del("n", "<Leader>l")
vim.keymap.set("n", "<Leader>pp", "<Cmd>Lazy<CR>", { desc = "Plugins Manager" })

vim.keymap.del({ "n", "v" }, "<Leader>cf")
vim.keymap.set({ "n", "v" }, "<Leader>lf", function()
  lazyutil.format({ force = true })
end, { desc = "Format" })
vim.keymap.set({ "n", "v", "i" }, "<A-F>", function()
  lazyutil.format({ force = true })
end, { desc = "Format" })

vim.keymap.del("n", "<Leader>cd")
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

local lazyterm = function()
  lazyutil.terminal(vim.fn.executable("pwsh") and "pwsh" or nil)
end
vim.keymap.set("n", "<Leader>ft", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<A-`>", lazyterm, { desc = "Terminal (root dir)" })

vim.keymap.del("n", "<Leader><Tab>l")
vim.keymap.del("n", "<Leader><Tab>f")
vim.keymap.del("n", "<Leader><Tab><Tab>")
vim.keymap.del("n", "<Leader><Tab>]")
vim.keymap.del("n", "<Leader><Tab>d")
vim.keymap.del("n", "<Leader><Tab>[")
vim.keymap.set("n", "<Leader>tt", "<Cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<Leader>t0", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<Leader>t$", "<Cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "<Leader>tn", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<Leader>tp", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<Leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })

-- Buffers
vim.keymap.set("n", "<Leader><Tab><Tab>", "<Cmd>try<Bar>b#<Bar>catch<Bar>endtry<CR>", { desc = "Switch Buffer" })
vim.keymap.set("n", "<Leader>bw", "<Cmd>noautocmd w<CR>", { desc = "Save Without Format" })

-- Windows
vim.keymap.set("n", "<Tab>", keymaps.switch_window(true), { desc = "Next Window" })
vim.keymap.set("n", "<S-Tab>", keymaps.switch_window(), { desc = "Prev Window" })
vim.keymap.set("n", "<C-w>z", keymaps.zoom_window, { desc = "Zoom Window" })

-- Search: simulate vscode search mode
vim.keymap.set("c", "<A-w>", keymaps.toggle_search_pattern("w"), { desc = "Match Whole Word" })
vim.keymap.set("c", "<A-c>", keymaps.toggle_search_pattern("c"), { desc = "Match Case" })
vim.keymap.set("c", "<A-r>", keymaps.toggle_search_pattern("r"), { desc = "Toggle Very Magic" })

-- Motions
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

-- Motion: mark
vim.keymap.set("", "'", "`", { remap = true, desc = "Jump To Mark" })

-- Motion: jump list
-- HACK: For historical reason, <Tab> and <C-i> have the same key sequence in most of terminals.
-- To distinguish them, you could map another key, say <A-I>, to <C-i> in neovim,
-- and then map ctrl+i to send <A-I> key sequence in your terminal setting.
-- For more info `:h tui-modifyOtherKeys` and https://invisible-island.net/xterm/modified-keys.html
vim.keymap.set({ "i", "c", "n", "x", "s" }, "<M-I>", "<C-i>", { desc = "Go TO Last Jump Position" })

-- Operation: better indenting
vim.keymap.set("n", "<", "<<", { desc = "Deindent" })
vim.keymap.set("n", ">", ">>", { desc = "Indent" })

-- Operation: add empty lines
vim.keymap.set(
  "n",
  "]<Space>",
  "v:lua.require'user.keymaps'.put_empty_line(v:false)",
  { expr = true, desc = "Put Empty Line Below" }
)
vim.keymap.set(
  "n",
  "[<Space>",
  "v:lua.require'user.keymaps'.put_empty_line(v:true)",
  { expr = true, desc = "Put Empty Line Above" }
)

-- Operation: add undo break-points
vim.keymap.set("c", "<C-k>", function()
  local text = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  if text and col - 1 < #text then
    vim.fn.setcmdline(text:sub(1, col - 1))
  end
end)
vim.keymap.set("i", "<C-j>", "<C-g>u<End><CR>")
vim.keymap.set("i", "<C-k>", '<C-g>u<Cmd>normal! "_d$<CR><Right>')
vim.keymap.set("i", "<C-z>", "<Cmd>undo<CR>")

-- Operation: yank and paste
vim.keymap.set("i", "<C-v>", "<C-g>u<C-r><C-p>+")
vim.keymap.set("c", "<C-v>", "<C-r>+")
