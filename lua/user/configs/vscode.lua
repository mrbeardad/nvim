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
-- Motion: basic move
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End Of Line" })
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
vim.keymap.set("c", "<C-d>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<A-d>", '<C-g>u<Cmd>normal! "_dw<CR>')
vim.keymap.set("c", "<C-k>", function()
  local text = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  if text and col - 1 < #text then
    vim.fn.setcmdline(text:sub(1, col - 1))
  end
end)
vim.keymap.set("i", "<C-k>", '<C-g>u<Cmd>normal! "_d$<CR><Right>')
vim.keymap.set("i", "<C-j>", "<C-g>u<End><CR>")
-- Operation: yank and paste
vim.keymap.set("i", "<C-v>", "<C-g>u<C-r><C-p>+")
vim.keymap.set("c", "<C-v>", "<C-r>+")
-- Operation: undo
vim.keymap.set("i", "<C-z>", "<Cmd>normal u<CR>")
-- Operation: repeat
vim.keymap.del("x", "mi")
vim.keymap.del("x", "mI")
vim.keymap.del("x", "ma")
vim.keymap.del("x", "mA")
