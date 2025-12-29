-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local util = require("util")

-- Buffers
vim.keymap.del("n", "<Leader>,")
vim.keymap.set("n", "<Leader><Tab>", "<Cmd>try<Bar>b#<Bar>catch<Bar>endtry<CR>", { desc = "Switch Buffer" })
vim.keymap.set("n", "<Leader><Tab><Tab>", "<Leader>fb", { desc = "Find Buffers", remap = true })
vim.keymap.set("n", "<Leader>bw", "<Cmd>noautocmd w<CR>", { desc = "Write without Format" })

-- Windows
vim.keymap.set("n", "<Tab>", util.switch_window(true), { desc = "Next Window" })
vim.keymap.set("n", "<S-Tab>", util.switch_window(), { desc = "Prev Window" })

-- Tabs
vim.keymap.del("n", "<Leader><Tab>l")
vim.keymap.del("n", "<Leader><Tab>o")
vim.keymap.del("n", "<Leader><Tab>f")
vim.keymap.del("n", "<Leader><Tab>]")
vim.keymap.del("n", "<Leader><Tab>d")
vim.keymap.del("n", "<Leader><Tab>[")
vim.keymap.set("n", "<Leader>tl", "<Cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "<Leader>to", "<Cmd>tabonly<CR>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<Leader>tf", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<Leader>tt", "<Cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<Leader>t]", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<Leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<Leader>t[", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })

-- VSCode
if vim.g.vscode then
  local function vscode_action(cmd)
    return function()
      require("vscode").action(cmd)
    end
  end

  -- Buffers
  vim.keymap.set(
    "n",
    "<Leader>bo",
    vscode_action("workbench.action.closeOtherEditors"),
    { desc = "Close Other Editors" }
  )
  vim.keymap.set(
    "n",
    "<Leader>bl",
    vscode_action("workbench.action.closeEditorsToTheLeft"),
    { desc = "Close Left Editors" }
  )
  vim.keymap.set(
    "n",
    "<Leader>br",
    vscode_action("workbench.action.closeEditorsToTheRight"),
    { desc = "Close Right Editors" }
  )

  -- Windows
  vim.keymap.set("n", "<Tab>", vscode_action("workbench.action.focusNextGroup"), { desc = "Next Window" })
  vim.keymap.set("n", "<S-Tab>", vscode_action("workbench.action.focusNextGroup"), { desc = "Prev Window" })

  -- Search
  vim.keymap.set("n", "gy", vscode_action("editor.action.goToTypeDefinition"), { desc = "Go To Type Definition" })
  vim.keymap.set("n", "gr", vscode_action("editor.action.goToReferences"), { desc = "Go To References" })
  vim.keymap.set("n", "gI", vscode_action("editor.action.goToImplementation"), { desc = "Go To Implementations" })

  -- Motion
  vim.keymap.set({ "n", "x" }, "<C-o>", vscode_action("workbench.action.navigateBack"), { desc = "Go Back" })
  vim.keymap.set({ "n", "x" }, "<C-i>", vscode_action("workbench.action.navigateForward"), { desc = "Go Forward" })
  vim.keymap.set("n", "]h", function()
    require("vscode").action("workbench.action.editor.nextChange")
    require("vscode").action("workbench.action.compareEditor.nextChange")
  end, { desc = "Next Git Diff" })
  vim.keymap.set("n", "[h", function()
    require("vscode").action("workbench.action.editor.previousChange")
    require("vscode").action("workbench.action.compareEditor.previousChange")
  end, { desc = "Prev Git Diff" })
  vim.keymap.set("n", "]d", vscode_action("editor.action.marker.next"), { desc = "Next Diagnostic" })
  vim.keymap.set("n", "[d", vscode_action("editor.action.marker.prev"), { desc = "Prev Diagnostic" })

  -- Operation: repeat
  vim.keymap.del("x", "mi")
  vim.keymap.del("x", "mI")
  vim.keymap.del("x", "ma")
  vim.keymap.del("x", "mA")
end

-- Scroll
vim.keymap.set({ "n", "x" }, "<M-f>", "zL", { desc = "Scroll Right" })
vim.keymap.set({ "n", "x" }, "<M-b>", "zH", { desc = "Scroll Left" })

-- Motion
vim.keymap.set("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End Of Line" })

-- HACK: For historical reason, <Tab> and <C-I> have the same key sequence in most of terminals.
-- To distinguish them, you could map another key, says <M-I>, to <C-I> in neovim,
-- and then map ctrl+i to send <M-I> key sequence in your terminal setting.
-- For more info `:h tui-input` and https://invisible-island.net/xterm/modified-keys.html
vim.keymap.set({ "i", "c", "n", "v", "t" }, "<M-`>", "<C-`>", { desc = "<C-`>", remap = true })
vim.keymap.set({ "i", "c", "n", "v" }, "<M-I>", "<C-I>", { desc = "<C-I>" })
vim.keymap.set({ "i", "c", "n", "v" }, "<M-J>", "<C-S-J>", { desc = "<C-S-J>", remap = true })

-- Operation: visual word
vim.keymap.set({ "x" }, "v", "iw", { desc = "Delete Without Register", remap = true })

-- Operation: better delete
vim.keymap.set({ "n", "x" }, "<M-d>", '"_d', { desc = "Delete Without Register" })
vim.keymap.set({ "n", "x" }, "<M-c>", '"_c', { desc = "Change Without Register" })
vim.keymap.set({ "c", "i" }, "<C-d>", "<Del>", { desc = "Delete Right" })
vim.keymap.set("i", "<M-d>", '<C-g>u<Cmd>normal! "_dw<CR>', { desc = "Delete Right Word" })
vim.keymap.set("i", "<C-k>", '<C-g>u<Cmd>normal! "_d$<CR><Right>', { desc = "Delete All Right" })
vim.keymap.set("c", "<C-k>", function()
  local text = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  if text and col - 1 < #text then
    vim.fn.setcmdline(text:sub(1, col - 1))
  end
end)

-- Operation: better indenting
vim.keymap.set("n", "<", "<<", { desc = "Deindent" })
vim.keymap.set("n", ">", ">>", { desc = "Indent" })
vim.keymap.set("x", "<", "<gv", { desc = "Deindent" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent" })

-- Operation: better yank and paste
vim.keymap.set("x", "<C-c>", "y", { desc = "Yank" })
vim.keymap.set("i", "<C-v>", "<C-g>u<C-r><C-p>+", { desc = "Paste Last Yanked" })
vim.keymap.set("c", "<C-v>", "<C-r>+", { desc = "Paste Last Yanked" })

-- Operation: better undo
vim.keymap.set("i", "<C-z>", "<Cmd>normal u<CR>", { desc = "Undo" })

-- Format
vim.keymap.set({ "n", "x" }, "<M-F>", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

-- LSP
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grn")
vim.keymap.del({ "n", "x" }, "gra")

-- Toggle Wrap
vim.keymap.set("n", "<M-z>", "<Cmd>setlocal wrap!<CR>", { desc = "Toggle 'wrap'" })

-- Misc
vim.keymap.set("n", "g8", function()
  local ga = vim.fn.execute("ascii")
  vim.cmd("silent normal! g8")
  vim.print(ga .. ", UTF-8: " .. vim.v.statusmsg)
end, { desc = "Ascii and Utf-8" })
