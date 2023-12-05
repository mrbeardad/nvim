local M = {}

local keymap = require("user.which-key").keymap

M.config = function()
	vim.opt.pumblend = 15
	vim.opt.winblend = 15
	vim.opt.showcmd = true
	vim.opt.cmdheight = 0
	vim.opt.list = true
	vim.opt.listchars = "tab:→ ,eol:↵,trail:·,extends:↷,precedes:↶"
	vim.opt.colorcolumn = "80"
	vim.opt.relativenumber = true

	lvim.builtin.lualine.sections.lualine_y = { { "fileformat" }, { "encoding" } }
	lvim.builtin.lualine.sections.lualine_z = { { " %c  %l/%L", type = "stl" } }
	lvim.builtin.bufferline.options.always_show_bufferline = true

	table.insert(lvim.plugins, {
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
	})
	keymap("n", "<C-S-U>", "<Cmd>Noice<CR>")

	table.insert(lvim.plugins, {
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			max_lines = 1,
		},
	})

	table.insert(lvim.plugins, {
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	})

	table.insert(lvim.plugins, {
		"norcalli/nvim-colorizer.lua",
		opts = {},
	})
end

return M
