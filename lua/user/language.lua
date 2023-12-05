local M = {}

local keymap = require("user.which-key").keymap
local cmp = require("lvim.utils.modules").require_on_index("cmp")

M.config = function()
	-- complete
	lvim.builtin.cmp.confirm_opts.select = true

	lvim.builtin.cmp.mapping["<C-j>"] = nil
	lvim.builtin.cmp.mapping["<C-J>"] = nil

	lvim.builtin.cmp.mapping["<C-k>"] = nil
	lvim.builtin.cmp.mapping["<C-K>"] = nil

	lvim.builtin.cmp.mapping["<C-S-I>"] = cmp.mapping(function()
		if cmp.visible() then
			cmp.abort()
		else
			cmp.complete()
		end
	end)

	local cmp_mapping_tab = lvim.builtin.cmp.mapping["<Tab>"]
	lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			lvim.builtin.cmp.mapping["<CR>"].i(fallback)
		else
			cmp_mapping_tab[vim.api.nvim_get_mode().mode:sub(1, 1)](fallback)
		end
	end, { "i", "s" })

	local cmp_mapping_shift_tab = lvim.builtin.cmp.mapping["<S-Tab>"]
	lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			lvim.builtin.cmp.mapping["<C-Y>"].i(fallback)
		else
			cmp_mapping_shift_tab[vim.api.nvim_get_mode().mode:sub(1, 1)](fallback)
		end
	end, { "i", "s" })

	table.insert(lvim.plugins, {
		"ray-x/lsp_signature.nvim",
		opts = {
			-- hint_prefix = " ",
		},
		cond = false,
	})

	-- code action
	keymap("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>")
	keymap("n", "<C-.>", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
	keymap("n", "<M-.>", "<Cmd>lua vim.lsp.buf.code_action()<CR>")

	-- comment
	lvim.builtin.comment.toggler.line = "<C-/>"
	lvim.builtin.comment.opleader.line = "<C-/>"
	keymap("i", "<C-/>", '<Cmd>exe "normal \\<C-/>"<CR>')
	keymap({ "n", "x", "i" }, "<C-_>", "<C-/>", { remap = true })

	-- format
	lvim.format_on_save.enabled = true
	require("lvim.lsp.null-ls.formatters").setup({
		{ name = "ruff" },
		{ name = "prettier" },
		{ name = "shfmt" },
		{ name = "sqlfluff" },
		{ name = "stylua" },
	})
	keymap({ "n", "v", "i" }, "<M-F>", "<Cmd>lua vim.lsp.buf.format()<CR>")

	-- lint
	require("lvim.lsp.null-ls.linters").setup({
		{ name = "ruff" },
		{ name = "eslint_d" },
		{ name = "shellcheck" },
		{ name = "sqlfluff", args = { "--dialect", "postgres" } },
	})

	-- symbols
	table.insert(lvim.plugins, {
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
		opts = {
			width = 20,
			autofold_depth = 1,
		},
		config = function(plugin, opts)
			require("symbols-outline").setup(opts)
			require("symbols-outline.config").get_split_command = function()
				local nvimtree_winnr = require("nvim-tree.view").get_winnr()
				-- if nvim-tree is opened, open symbols-outline below it
				if nvimtree_winnr and vim.api.nvim_win_is_valid(nvimtree_winnr) then
					vim.api.nvim_set_current_win(nvimtree_winnr)
					vim.cmd("belowright sp")
					local winnr = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_option(winnr, "signcolumn", "no")
					vim.api.nvim_win_set_option(winnr, "winfixheight", true)
					return ""
				else
					return opts.position == "left" and "topleft vs" or "botright vs"
				end
			end
		end,
	})
end

return M
