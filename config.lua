require("user.neovim").config()

-- In order to disable lunarvim's default colorscheme
lvim.colorscheme = "default"

lvim.builtin.bufferline.options.always_show_bufferline = true

require("user.statusline").config()

require("user.alpha").config()

lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.terminal.shell = "/bin/bash"
lvim.builtin.terminal.open_mapping = "<C-Space>"
lvim.builtin.nvimtree.setup.view.mappings.list = {
	{ key = { "<Tab>" }, action = nil },
	{ key = { "l", "<CR>" }, action = "edit", mode = "n" },
	{ key = "h", action = "close_node" },
	{ key = "v", action = "vsplit" },
}

----------------------------------------
-- Telescope
----------------------------------------
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<Esc>"] = actions.close,
	},
	-- for normal mode
	n = {},
}

require("user.treesitter").config()

require("user.lsp").config()

require("user.plugins").config()

require("user.keybindings").config()
