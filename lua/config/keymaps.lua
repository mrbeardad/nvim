-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local lazyutil = require("lazyvim.util")
local keymaps = require("user.keymaps")

-- Change LazyVim builtin keymaps
vim.keymap.set("i", "<A-j>", "<cmd>m .+1<bar>normal ==<cr>", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<cmd>m .-2<bar>normal ==<cr>", { desc = "Move Up" })

vim.keymap.del("i", ",")
vim.keymap.del("i", ".")
vim.keymap.del("i", ";")

vim.keymap.set({ "n", "v", "i" }, "<A-F>", function()
  lazyutil.format({ force = true })
end, { desc = "Format" })

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

local lazyterm = function()
  lazyutil.terminal(vim.fn.executable("pwsh") and "pwsh" or nil)
end
vim.keymap.set("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<A-`>", lazyterm, { desc = "Terminal (root dir)" })

vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>t0", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader>t$", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- Buffers
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>try<bar>b#<Bar>catch<Bar>endtry<cr>", { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>bw", "<cmd>noautocmd w<cr>", { desc = "Save Without Format" })

-- Windows
vim.keymap.set("n", "<tab>", keymaps.switch_window(true), { desc = "Next Window" })
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
vim.keymap.set("i", "<C-a>", "<C-g>u<cmd>normal! ^<cr>", { desc = "Start Of Line" })
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
-- HACK: For historical reason, <tab> and <C-i> have the same key sequence in most of terminals.
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
  "]<space>",
  "v:lua.require'user.keymaps'.put_empty_line(v:false)",
  { expr = true, desc = "Put Empty Line Below" }
)
vim.keymap.set(
  "n",
  "[<space>",
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
vim.keymap.set("i", "<C-j>", "<C-g>u<End><cr>")
vim.keymap.set("i", "<C-k>", '<C-g>u<cmd>normal! "_d$<cr><Right>')
vim.keymap.set("i", "<C-z>", "<cmd>undo<cr>")

-- Operation: yank and paste
vim.keymap.set("i", "<C-v>", "<C-g>u<C-r><C-p>+")
vim.keymap.set("c", "<C-v>", "<C-r>+")
