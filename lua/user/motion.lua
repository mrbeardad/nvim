local M = {}

local keymap = require("user.which-key").keymap

M.flash_select = function()
	local selected_labels = {}

	local find_label = function(match)
		for i, pos in ipairs(selected_labels) do
			if pos[1] == match.pos[1] and pos[2] == match.pos[2] then
				return i
			end
		end
		return nil
	end

	require("flash").jump({
		search = {
			mode = "search",
		},
		jump = {
			pos = "range",
		},
		label = {
			format = function(opts)
				return {
					{
						opts.match.label,
						find_label(opts.match) and opts.hl_group or "FlashLabelUnselected",
					},
				}
			end,
		},
		action = function(match, state)
			local i = find_label(match)
			if i then
				table.remove(selected_labels, i)
			else
				table.insert(selected_labels, match.pos)
			end
			state:_update()
			require("flash").jump({ continue = true })
		end,
	})

	return selected_labels
end

M.config = function()
	------------------
	-- Flash
	------------------
	table.insert(lvim.plugins, {
		"folke/flash.nvim",
		event = "CmdlineEnter",
		keys = {
			{ "f", mode = { "n", "x", "o" } },
			{ "F", mode = { "n", "x", "o" } },
			{ "t", mode = { "n", "x", "o" } },
			{ "T", mode = { "n", "x", "o" } },
			{ ";", mode = { "n", "x", "o" } },
			{ ",", mode = { "n", "x", "o" } },
			{ "r", "<Cmd>lua require('flash').remote({restore=true})<CR>", mode = "o" },
		},
		opts = {
			label = {
				after = false,
				before = true,
			},
			modes = {
				char = {
					highlight = { backdrop = false },
					label = { exclude = "ryipasdhjklxcvYPSDJKXCV" },
					jump_labels = true,
					autohide = true,
					char_actions = function(motion)
						return {
							[";"] = "next",
							[","] = "prev",
							[motion:lower()] = "right",
							[motion:upper()] = "left",
						}
					end,
				},
			},
		},
	})

	------------------
	-- Matchup
	------------------
	lvim.builtin.treesitter.matchup = { enable = true }
	table.insert(lvim.plugins, {
		"andymass/vim-matchup",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			if vim.g.vscode then
				vim.g.matchup_matchparen_enabled = 0
			else
				vim.g.matchup_matchparen_offscreen = { method = "popup" }
			end
		end,
	})

	------------------
	-- Marks
	------------------
	table.insert(lvim.plugins, {
		"chentoast/marks.nvim",
		opts = {},
		cond = not vim.g.vscode,
	})

	keymap({ "n", "x" }, "'", "`", { remap = true }) -- remap to which-key builtin marks key

	if vim.g.vscode then
		local vscode = require("vscode-neovim")
		vim.keymap.set({ "n" }, "m;", function()
			vscode.action("bookmarks.toggle")
		end)
		vim.keymap.set({ "n" }, "m:", function()
			vscode.action("bookmarks.toggleLabeled")
		end)
		vim.keymap.set({ "n" }, "m/", function()
			vscode.action("bookmarks.listFromAllFiles")
		end)
	else
		vim.api.nvim_create_autocmd("BufRead", {
			pattern = "*",
			callback = function()
				vim.api.nvim_create_autocmd("FileType", {
					buffer = 0,
					once = true,
					callback = function()
						if
							not vim.o.ft:find("commit|rebase")
							and vim.fn.line("'\"") > 1
							and vim.fn.line("'\"") <= vim.fn.line("$")
						then
							vim.cmd('normal! g`"zz')
						end
					end,
				})
			end,
			desc = "Jump to last exit position",
		})
	end

	------------------
	-- Jump List
	------------------
	vim.o.jumpoptions = "stack"
	-- HACK: For historical reason, <Tab> and <C-i> have the same key sequence in most of terminals.
	-- To distinguish them, you could map another key, say <C-S-I>, to <C-i> in neovim,
	-- and then map ctrl+i to send <C-S-I> key sequence in your terminal setting.
	-- For more info `:h tui-modifyOtherKeys` or https://invisible-island.net/xterm/modified-keys.html
	keymap({ "n" }, "<C-S-I>", "<C-i>")
end

return M
