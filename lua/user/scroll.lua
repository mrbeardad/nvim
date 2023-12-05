local M = {}

local keymap = require("user.which-key").keymap

M.config = function()
	table.insert(lvim.plugins, {
		"karb94/neoscroll.nvim",
		keys = {
			{ "<C-y>", mode = { "n", "x" } },
			{ "<C-e>", mode = { "n", "x" } },
			{ "<C-u>", mode = { "n", "x" } },
			{ "<C-d>", mode = { "n", "x" } },
			{ "<C-b>", mode = { "n", "x" } },
			{ "<C-f>", mode = { "n", "x" } },
			{ "zt", mode = { "n", "x" } },
			{ "zz", mode = { "n", "x" } },
			{ "zb", mode = { "n", "x" } },
			{ "z<CR>", "zt", mode = { "n", "x" }, remap = true },
		},
		opts = {
			easing_function = "quartic",
		},
		cond = not vim.g.vscode,
	})

	table.insert(lvim.plugins, {
		"petertriho/nvim-scrollbar",
		opts = {
			handle = {
				highlight = "ScrollbarHandle",
			},
			handlers = {
				cursor = false,
				diagnostic = true,
				gitsigns = true, -- Requires gitsigns
				search = true, -- Requires hlslens
			},
		},
		cond = not vim.g.vscode,
	})

	if vim.g.vscode then
		local vscode = require("vscode-neovim")
		keymap("n", "zh", function()
			vscode.call("scrollLeft")
		end)
		keymap("n", "zl", function()
			vscode.call("scrollRight")
		end)
	end
end

return M
