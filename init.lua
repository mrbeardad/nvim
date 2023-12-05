local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
local function join_paths(...)
	local result = table.concat({ ... }, path_sep)
	return result
end

vim.env.ErrorActionPreference = "Stop"

vim.env.XDG_DATA_HOME = vim.env.XDG_DATA_HOME or vim.env.APPDATA
vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.LOCALAPPDATA
vim.env.XDG_CACHE_HOME = vim.env.XDG_CACHE_HOME or vim.env.TEMP

vim.env.LUNARVIM_RUNTIME_DIR = join_paths(vim.env.XDG_DATA_HOME, "lunarvim")
vim.env.LUNARVIM_CONFIG_DIR = join_paths(vim.env.XDG_CONFIG_HOME, "lvim")
vim.env.LUNARVIM_CACHE_DIR = join_paths(vim.env.XDG_CACHE_HOME, "lvim")
vim.env.LUNARVIM_BASE_DIR = join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "lvim")

if vim.g.vscode then
	-- load lvim config
	vim.notify = require("vscode-neovim").notify

	vim.opt.runtimepath:prepend(vim.env.LUNARVIM_CONFIG_DIR)
	vim.opt.runtimepath:prepend(join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "site", "pack", "lazy", "opt", "lazy.nvim"))

	lvim = {
		plugins = {},
		builtin = {
			treesitter = {},
			telescope = { defaults = {}, extensions = {} },
		},
	}

	table.insert(lvim.plugins, {
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup(lvim.builtin.treesitter)
		end,
	})

	vim.cmd("source " .. join_paths(vim.env.LUNARVIM_CONFIG_DIR, "config.lua"))

	require("lazy").setup(lvim.plugins, {
		root = join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "site", "pack", "lazy", "opt"),
		readme = { root = join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "lazy", "readme") },
	})
else
	-- load lunarvim
	vim.cmd("source " .. join_paths(vim.env.LUNARVIM_BASE_DIR, "init.lua"))
end

-- require("lazy").setup({
-- 	{
-- 		"folke/flash.nvim",
-- 		event = "CmdlineEnter",
-- 		keys = {
-- 			{ "f", mode = { "n", "x", "o" } },
-- 			{ "F", mode = { "n", "x", "o" } },
-- 			{ "t", mode = { "n", "x", "o" } },
-- 			{ "T", mode = { "n", "x", "o" } },
-- 			{ ";", mode = { "n", "x", "o" } },
-- 			{ ",", mode = { "n", "x", "o" } },
-- 			{
-- 				"r",
-- 				function()
-- 					require("flash").remote()
-- 				end,
-- 				mode = "o",
-- 			},
-- 			{
-- 				"mc/",
-- 				function()
-- 					require("flash").jump({
-- 						search = {
-- 							mode = "search",
-- 						},
-- 						label = {
-- 							format = function(opts)
-- 								-- NOTE: match 仅在pattern不变时缓存，更新渲染在action之后才调用
-- 								-- vim.cmd("echo '" .. tostring(opts.match.highlight) .. tostring(opts.match) .. "'")
-- 								return {
-- 									{ opts.match.label, not opts.match.highlight and "FlashLabelCustom" or "Error" },
-- 								}
-- 							end,
-- 						},
-- 						action = function(match, state)
-- 							vim.cmd("echo '" .. tostring(match.highlight) .. tostring(match) .. "'")
-- 							match.highlight = not match.highlight
-- 							state:_update()
-- 							require("flash").jump({ continue = true })
-- 						end,
-- 					})
-- 					-- vim.schedule(function()
-- 					-- 	for idx, pos in pairs(last_multiple_cursor_pos) do
-- 					-- 		require("multiple-cursors").add_cursor(pos[1], pos[2] + 1, pos[2] + 1)
-- 					-- 		if idx == #last_multiple_cursor_pos then
-- 					-- 			vim.api.nvim_win_set_cursor(0, last_multiple_cursor_pos[#last_multiple_cursor_pos])
-- 					-- 		end
-- 					-- 	end
-- 					-- 	last_multiple_cursor_pos = {}
-- 					-- end)
-- 				end,
-- 			},
-- 		},
-- 		opts = {
-- 			label = {
-- 				after = false,
-- 				before = true,
-- 			},
-- 			modes = {
-- 				char = {
-- 					-- multi_line = false,
-- 					jump = { autojump = true },
-- 					highlight = { backdrop = false },
-- 					config = function(opts)
-- 						-- Show jump labels only in operator-pending mode,
-- 						-- and not using a count or when recording/executing registers
-- 						opts.jump_labels = vim.fn.mode(true):find("o")
-- 							and vim.v.count == 0
-- 							and vim.fn.reg_executing() == ""
-- 							and vim.fn.reg_recording() == ""
-- 					end,
-- 					char_actions = function(motion)
-- 						return {
-- 							[";"] = "right",
-- 							[","] = "left",
-- 							[motion:lower()] = "right",
-- 							[motion:upper()] = "left",
-- 						}
-- 					end,
-- 				},
-- 			},
-- 			highlight = { groups = { label = "FlashLabelCustom" } },
-- 		},
-- 		config = function(plugin, opts)
-- 			require("flash").setup(opts)
-- 			vim.o.termguicolors = true
-- 			vim.cmd("hi FlashLabelCustom gui=bolditalic guifg=#f9f8f8 guibg=#ff007c")
-- 		end,
-- 	},
-- {
-- 	"kevinhwang91/nvim-hlslens",
-- 	keys = {
-- 		{
-- 			"n",
-- 			[[<Cmd>execute("normal! " . v:count1 . "Nn"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
-- 		},
-- 		{
-- 			"N",
-- 			[[<Cmd>execute("normal! " . v:count1 . "nN"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
-- 		},
-- 		{ "*", [[*<Cmd>lua require("hlslens").start()<CR>]] },
-- 		{ "#", [[#<Cmd>lua require("hlslens").start()<CR>]] },
-- 		{ "g*", [[g*<Cmd>lua require("hlslens").start()<CR>]] },
-- 		{ "g#", [[g#<Cmd>lua require("hlslens").start()<CR>]] },
-- 	},
-- 	opts = {
-- 		calm_down = true,
-- 		override_lens = function(render, posList, nearest, idx, relIdx)
-- 			local sfw = vim.v.searchforward == 1
-- 			local indicator, text, chunks
-- 			local absRelIdx = math.abs(relIdx)
-- 			if absRelIdx > 1 then
-- 				indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
-- 			elseif absRelIdx == 1 then
-- 				indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
-- 			else
-- 				indicator = ""
-- 			end
-- 			local lnum, col = unpack(posList[idx])
-- 			if nearest then
-- 				local cnt = #posList
-- 				if indicator ~= "" then
-- 					text = ("[%s %d/%d]"):format(indicator, idx, cnt)
-- 				else
-- 					text = ("[%d/%d]"):format(idx, cnt)
-- 				end
-- 				chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
-- 			else
-- 				text = ("[%s %d]"):format(indicator, idx)
-- 				chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
-- 			end
-- 			render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
-- 		end,
-- 	},
-- 	config = function(plugin, opts)
-- 		require("hlslens").setup(opts)
-- 		-- To clear and redraw in vscode
-- 		require("hlslens.lib.event"):on(
-- 			"LensUpdated",
-- 			function(bufnr, pattern, changedtick, sList, eList, idx, rIdx, region)
-- 				vim.cmd("mod")
-- 			end,
-- 			{}
-- 		)
-- 		vim.cmd("hi HlSearchLensNear guibg=#40bf6a guifg=#062e32")
-- 		vim.cmd("hi HlSearchLens guibg=#0a5e69 guifg=#b2cac3")
-- 	end,
-- },
-- {
-- 	"vscode-neovim/vscode-multi-cursor.nvim",
-- 	keys = {
-- 		{
-- 			"mc",
-- 			function()
-- 				return require("vscode-multi-cursor").create_cursor()
-- 			end,
-- 			mode = { "n", "x" },
-- 			expr = true,
-- 			desc = "Create cursor",
-- 		},
-- 		{
-- 			"mcc",
-- 			function()
-- 				return require("vscode-multi-cursor").cancel()
-- 			end,
-- 			mode = { "n" },
-- 			desc = "Clear all cursors",
-- 		},
-- 		{
-- 			"mc/",
-- 			function()
-- 				require("flash").jump({
-- 					search = {
-- 						multi_window = false,
-- 						mode = "search",
-- 					},
-- 					jump = { pos = "range" },
-- 					action = function(match)
-- 						match.highlight = false
-- 						local pos = match.pos
-- 						if #vim.fn.getline(pos[1]) > 0 then
-- 							require("vscode-multi-cursor.state").add_cursor(
-- 								require("vscode-multi-cursor.cursor").new(pos, match.end_pos)
-- 							)
-- 						end
-- 						require("flash").jump({ continue = true })
-- 					end,
-- 				})
-- 			end,
-- 		},
-- 		{
-- 			"<C-n>",
-- 			function()
-- 				require("vscode-multi-cursor").addSelectionToNextFindMatch()
-- 			end,
-- 			mode = { "n", "x", "i" },
-- 		},
-- 		{
-- 			"<C-S-N>",
-- 			function()
-- 				require("vscode-multi-cursor").addSelectionToPreviousFindMatch()
-- 			end,
-- 			mode = { "n", "x", "i" },
-- 		},
-- 		{
-- 			"<C-S-L>",
-- 			function()
-- 				require("vscode-multi-cursor").selectHighlights()
-- 			end,
-- 			mode = { "n", "x", "i" },
-- 		},
-- 		{
-- 			"I",
-- 			function()
-- 				require("vscode-multi-cursor").start_left()
-- 				-- fallback to normal I
-- 				if vim.fn.mode() ~= "i" then
-- 					return "I"
-- 				end
-- 			end,
-- 			mode = { "n" },
-- 			expr = true,
-- 		},
-- 		{
-- 			"I",
-- 			function()
-- 				require("vscode-multi-cursor").start_left({ no_selection = true })
-- 			end,
-- 			mode = { "x" },
-- 		},
-- 		{
-- 			"A",
-- 			function()
-- 				require("vscode-multi-cursor").start_right()
-- 				-- fallback to normal A
-- 				if vim.fn.mode() ~= "i" then
-- 					return "A"
-- 				end
-- 			end,
-- 			mode = { "n" },
-- 			expr = true,
-- 		},
-- 		{
-- 			"A",
-- 			function()
-- 				require("vscode-multi-cursor").start_left({ no_selection = true })
-- 			end,
-- 			mode = { "x" },
-- 		},
-- 		{
-- 			"c",
-- 			function()
-- 				local mode = vim.fn.mode()
-- 				if mode == "V" or mode == "\x16" then
-- 					require("vscode-multi-cursor").start_right()
-- 					vscode.action("deleteLeft")
-- 				else
-- 					-- fallback to normal c when in visual character mode
-- 					return "c"
-- 				end
-- 			end,
-- 			mode = { "x" },
-- 			expr = true,
-- 		},
-- 	},
-- 	opts = {
-- 		default_mappings = false,
-- 	},
-- },
-- {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	config = function()
-- 		require("nvim-treesitter.configs").setup({
-- 			incremental_selection = {
-- 				enable = true,
-- 				keymaps = {
-- 					node_incremental = "v",
-- 					node_decremental = "V",
-- 				},
-- 			},
-- 			textobjects = {
-- 				select = {
-- 					enable = true,
-- 					keymaps = {
-- 						["af"] = "@function.outer",
-- 						["if"] = "@function.inner",
-- 						["ab"] = "@block.outer",
-- 						["ib"] = "@block.inner",
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- },
-- {
-- 	"andymass/vim-matchup",
-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
-- 	init = function()
-- 		vim.g.matchup_matchparen_enabled = 1
-- 		vim.keymap.set({ "n", "x" }, "[[", "<Plug>(matchup-[%)")
-- 		vim.keymap.set({ "n", "x" }, "]]", "<Plug>(matchup-]%)")
-- 		vim.keymap.set({ "n", "x" }, "][", "<Plug>(matchup-z%)")
-- 	end,
-- },
-- {
-- 	"nvim-treesitter/nvim-treesitter-textobjects",
-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
-- },
-- {
-- 	"tpope/vim-surround",
-- 	dependencies = { "tpope/vim-repeat" },
-- },
-- {
-- 	"sgur/vim-textobj-parameter",
-- 	dependencies = { "kana/vim-textobj-user" },
-- },
-- }, {
-- 	root = join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "site", "pack", "lazy", "opt"),
-- 	lockfile = join_paths(vim.env.LUNARVIM_CONFIG_DIR, "lazy-lock.json"),
-- 	readme = {
-- 		root = join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "lazy", "readme"),
-- 	},
-- })

-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
-- vim.opt.shortmess = "oOtTIcCFS"

-- vim.keymap.set({ "n" }, "mm", function()
-- 	vscode.action("bookmarks.toggle")
-- end)
-- vim.keymap.set({ "n" }, "mi", function()
-- 	vscode.action("bookmarks.toggleLabeled")
-- end)
-- vim.keymap.set({ "n" }, "ml", function()
-- 	vscode.action("bookmarks.listFromAllFiles")
-- end)
-- vim.keymap.set({ "n", "i" }, "<c-j>", function()
-- 	vscode.action("editor.action.insertLineAfter")
-- end)
-- vim.keymap.set({ "i" }, "<C-a>", "<Home>")
-- vim.keymap.set({ "i" }, "<C-e>", "<End>")
-- vim.keymap.set({ "i" }, "<C-l>", "<Esc>ea")
-- vim.keymap.set({ "i" }, "<C-z>", "<Cmd>undo<CR>")
-- vim.keymap.set({ "i" }, "<C-S-Z>", "<Cmd>redo<CR>")
-- vim.keymap.set({ "n" }, "S", "i<CR><Esc>")
-- vim.keymap.set({ "n", "x" }, "<", "<<")
-- vim.keymap.set({ "n", "x" }, ">", ">>")

-- vim.keymap.set({ "n", "x" }, "zp", [["0p]])
-- vim.keymap.set({ "n" }, "zP", [["0P]])
-- vim.keymap.set({ "n" }, "zo", [[<Cmd>put =@0<CR>]])
-- vim.keymap.set({ "n" }, "zO", [[<Cmd>put! =@0<CR>]])
-- vim.keymap.set({ "n" }, "zg", [[<Cmd>let @+ = @0<CR>]])
-- vim.keymap.set({ "n", "x" }, "gy", [["+y]])
-- vim.keymap.set({ "n" }, "gY", [["+y$]])
-- vim.keymap.set({ "n", "x" }, "gp", [["+p]])
-- vim.keymap.set({ "n" }, "gP", [["+P]])
-- vim.keymap.set({ "n" }, "go", [[<Cmd>put =@+<CR>]])
-- vim.keymap.set({ "n" }, "gO", [[<Cmd>put! =@+<CR>]])
-- vim.keymap.set({ "n", "x" }, "<C-c>", [["+y]])
-- vim.keymap.set({ "n" }, "<Space>by", [[<Cmd>%y +<CR>]])
-- vim.keymap.set({ "n" }, "<Space>bp", [[<Cmd>%d<CR>"+P]])

-- vim.keymap.set({ "n" }, "gr", function()
-- 	vscode.action("editor.action.goToReferences")
-- end)
-- vim.keymap.set({ "n" }, "gI", function()
-- 	vscode.action("editor.action.goToImplementation")
-- end)
-- vim.keymap.set({ "n" }, "<C-t>", function()
-- 	vscode.action("workbench.action.showAllSymbols")
-- end)
-- vim.keymap.set({ "n" }, "[d", function()
-- 	vscode.action("editor.action.marker.prev")
-- end)
-- vim.keymap.set({ "n" }, "]d", function()
-- 	vscode.action("editor.action.marker.next")
-- end)
-- vim.keymap.set({ "n", "x" }, "]c", function()
-- 	vscode.action("workbench.action.editor.nextChange")
-- 	vscode.action("workbench.action.compareEditor.nextChange")
-- end)
-- vim.keymap.set({ "n", "x" }, "[c", function()
-- 	vscode.action("workbench.action.editor.previousChange")
-- 	vscode.action("workbench.action.compareEditor.previousChange")
-- end)
-- vim.keymap.set({ "n" }, "H", function()
-- 	vscode.action("workbench.action.previousEditorInGroup")
-- end)
-- vim.keymap.set({ "n" }, "L", function()
-- 	vscode.action("workbench.action.nextEditorInGroup")
-- end)
-- vim.keymap.set({ "n" }, "<Tab>", function()
-- 	vscode.action("workbench.action.focusNextGroup")
-- end)
-- vim.keymap.set("n", "'", "`")
