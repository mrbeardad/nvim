local keymap = require("user.utils.keymap")
local utils = require("user.utils")
local vscode = require("vscode-neovim")

vim.notify = vscode.notify
vim.g.clipboard = vim.g.vscode_clipboard

-- Options
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.timeoutlen = 500
vim.opt.shortmess = "oOtTWIcCFS"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.virtualedit = "block"
vim.opt.jumpoptions = "stack"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.smartindent = true
vim.opt.formatoptions = "tcrqjnl"
vim.opt.clipboard = "unnamedplus"
vim.cmd.syntax("off")

-- Autocmds
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufAdd" }, {
  group = utils.augroup("LazyFile"),
  nested = true,
  callback = function()
    vim.api.nvim_del_augroup_by_id(utils.augroup("LazyFile"))
    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile" })
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = utils.augroup("HighlightYank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Search" })
  end,
})

-- Keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function vscode_action(cmd)
  return function()
    vscode.action(cmd)
  end
end

-- Editor: buffers
vim.keymap.set("n", "H", vscode_action("workbench.action.previousEditorInGroup"), { desc = "Previous Editor" })
vim.keymap.set("n", "L", vscode_action("workbench.action.nextEditorInGroup"), { desc = "Next Editor" })
vim.keymap.set("n", "<Leader>bo", vscode_action("workbench.action.closeOtherEditors"), { desc = "Close Other Editors" })
vim.keymap.set(
  "n",
  "<Leader>bh",
  vscode_action("workbench.action.closeEditorsToTheLeft"),
  { desc = "Close Left Editors" }
)
vim.keymap.set(
  "n",
  "<Leader>bl",
  vscode_action("workbench.action.closeEditorsToTheRight"),
  { desc = "Close Right Editors" }
)
-- Search: clear highlight
-- WARN: conflict with <Esc> of vscode-multi-cursor in operation.lua, set <esc> there
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR><Esc>", { desc = "Clear Highlight" })
-- Search: fix direction of n/N
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
-- Search: simulate vscode search mode
vim.keymap.set("c", "<A-w>", keymap.toggle_search_pattern("w"), { desc = "Match Whole Word" })
vim.keymap.set("c", "<A-c>", keymap.toggle_search_pattern("c"), { desc = "Match Case" })
vim.keymap.set("c", "<A-r>", keymap.toggle_search_pattern("r"), { desc = "Toggle Very Magic" })
-- Search: code navigation
vim.keymap.set("n", "gy", vscode_action("editor.action.goToTypeDefinition"), { desc = "Go To Type Definition" })
vim.keymap.set("n", "gr", vscode_action("editor.action.goToReferences"), { desc = "Go To References" })
vim.keymap.set("n", "gi", vscode_action("editor.action.goToImplementation"), { desc = "Go To Implementations" })
-- Scroll
vim.keymap.set("n", "zl", vscode_action("scrollRight"), { desc = "Scroll Right" })
vim.keymap.set("n", "zh", vscode_action("scrollLeft"), { desc = "Scroll Left" })
-- Motion: basic move
vim.keymap.set({ "n", "x" }, "j", function()
  if vim.v.count == 0 then
    vim.cmd("normal gj") -- vscode's gj
  else
    vim.cmd(string.format("normal! %dj", vim.v.count))
  end
end, { desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", function()
  if vim.v.count == 0 then
    vim.cmd("normal gk") -- vscode's gk
  else
    vim.cmd(string.format("normal! %dk", vim.v.count))
  end
end, { desc = "Down" })
vim.keymap.set("c", "<C-A>", "<C-B>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-A>", "<Home>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-E>", "<End>", { desc = "End Of Line" })
-- Motion: bookmark
vim.keymap.set({ "n" }, "m;", vscode_action("bookmarks.toggle"), { desc = "Toogle Bookmark" })
vim.keymap.set({ "n" }, "m:", vscode_action("bookmarks.toggleLabeled"), { desc = "Toogle Bookmark Label" })
vim.keymap.set({ "n" }, "m/", vscode_action("bookmarks.listFromAllFiles"), { desc = "List All Bookmarks" })
-- Motion: diagnostic
vim.keymap.set("n", "]g", function()
  vscode.action("workbench.action.editor.nextChange")
  vscode.action("workbench.action.compareEditor.nextChange")
end, { desc = "Next Git Diff" })
vim.keymap.set("n", "[g", function()
  vscode.action("workbench.action.editor.previousChange")
  vscode.action("workbench.action.compareEditor.previousChange")
end, { desc = "Prev Git Diff" })
vim.keymap.set("n", "]d", vscode_action("editor.action.marker.next"), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", vscode_action("editor.action.marker.prev"), { desc = "Prev Diagnostic" })
-- Operation: delete or change without register
vim.keymap.set({ "n", "x" }, "<A-d>", '"_d', { desc = "Delete Without Register" })
vim.keymap.set({ "n", "x" }, "<A-c>", '"_c', { desc = "Change Without Register" })
-- Operation: better indenting
vim.keymap.set("n", "<", "<<", { desc = "Deindent" })
vim.keymap.set("n", ">", ">>", { desc = "Indent" })
vim.keymap.set("x", "<", "<gv", { desc = "Deindent" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent" })
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
-- Operation: insert mode
vim.keymap.set("c", "<C-D>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<C-D>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<A-d>", '<C-G>u<Cmd>normal! "_dw<CR>')
vim.keymap.set("c", "<C-K>", function()
  local text = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  if text and col - 1 < #text then
    vim.fn.setcmdline(text:sub(1, col - 1))
  end
end)
vim.keymap.set("i", "<C-K>", '<C-G>u<Cmd>normal! "_d$<CR><Right>')
vim.keymap.set("i", "<C-J>", "<C-G>u<End><CR>")
-- Operation: yank and paste
vim.keymap.set("i", "<C-V>", "<C-G>u<C-R><C-P>+")
vim.keymap.set("c", "<C-V>", "<C-R>+")
-- Operation: undo
vim.keymap.set("i", "<C-Z>", "<Cmd>normal u<CR>")
-- Operation: repeat
vim.keymap.del("x", "mi")
vim.keymap.del("x", "mI")
vim.keymap.del("x", "ma")
vim.keymap.del("x", "mA")
