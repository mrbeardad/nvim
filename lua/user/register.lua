local M = {}

local keymap = require("user.which-key").keymap

M.config = function()
	vim.opt.clipboard = ""

	keymap({ "n", "x" }, "gy", [["+y]], { desc = "Yank to Clipboard", remap = true }) -- remap to which-key builtin operator
	keymap("n", "gY", [["+y$]], { desc = "Yank EOL to clip" })
	keymap("n", "zg", [[<Cmd>let @+ = @0<CR>]], { desc = "Copy last yank to clipboard" })

	keymap({ "n", "x" }, "zp", [["0p]], { desc = "Paste last yank after cursor" })
	keymap("n", "zP", [["0P]], { desc = "Paste last yank before cursor" })
	keymap("n", "zo", [[<Cmd>put =@0<CR>]], { desc = "Paste last yank to next line" })
	keymap("n", "zO", [[<Cmd>put! =@0<CR>]], { desc = "Paste last yank to previous line" })

	keymap({ "n", "x" }, "gp", [["+p]], { desc = "Paste from clip after cursor" })
	keymap("n", "gP", [["+P]], { desc = "Paste from clip before cursor" })
	keymap("n", "go", [[<Cmd>put =@+<CR>]], { desc = "Paste from clip after current line" })
	keymap("n", "gO", [[<Cmd>put! =@+<CR>]], { desc = "Paste from clip before current line" })
	keymap("n", "<Space>by", [[<Cmd>%y +<CR>]], { desc = "Yank whole buffer to Clip" })
	keymap("n", "<Space>bp", [[<Cmd>%d<CR>"+P]], { desc = "Paste clipboard override whole buffer" })
	keymap("x", "<C-c>", [["+y]])
	keymap("i", "<C-v>", "<C-g>u<C-r><C-p>+")
	keymap("c", "<C-v>", "<C-r>+")
end

return M
