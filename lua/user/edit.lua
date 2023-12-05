local M = {}

local keymap = require("user.which-key").keymap

local function add_cursors_in_visual(type)
	local mode = vim.api.nvim_get_mode().mode:sub(1, 1)

	if type == "c" then
		if mode == "v" or mode == "V" then
			vim.api.nvim_feedkeys("c", "n", false)
			return
		else
			vim.api.nvim_feedkeys("d", "nx", false)
			type = "i"
		end
	end

	-- escape to exit visual mode, then get previous visual range
	vim.api.nvim_feedkeys("\027", "nx", false)
	local start_pos = vim.api.nvim_buf_get_mark(0, "<")
	local end_pos = vim.api.nvim_buf_get_mark(0, ">")

	local orig_ve = vim.wo.virtualedit
	vim.wo.virtualedit = "onemore"
	vim.api.nvim_create_autocmd("InsertEnter", {
		once = true,
		callback = function()
			vim.wo.virtualedit = orig_ve
		end,
	})

	if mode == "v" then
		if type == "i" then
			vim.api.nvim_win_set_cursor(0, { start_pos[1], start_pos[2] })
		else
			vim.api.nvim_win_set_cursor(0, { end_pos[1], end_pos[2] })
		end
		vim.api.nvim_input(type)
	elseif mode == "V" then
		local col = type == "i" and start_pos[2] or end_pos[2]
		local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
		vim.api.nvim_win_set_cursor(0, { cursor_row, col })
		local start_row = cursor_row == start_pos[1] and start_pos[1] + 1 or start_pos[1]
		local end_row = cursor_row == start_pos[1] and end_pos[1] or end_pos[1] - 1
		for row = start_row, end_row do
			if #vim.fn.getline(row) > 0 then
				require("multiple-cursors").add_cursor(row, col, col)
			end
		end
		vim.api.nvim_input("i")
	else
		local start_vc = vim.fn.virtcol("'<")
		local end_vc = vim.fn.virtcol("'>")
		local start_dw = vim.fn.strdisplaywidth(
			vim.api.nvim_buf_get_text(0, start_pos[1] - 1, 0, start_pos[1] - 1, start_pos[2], {})[1]
		)
		local end_dw =
			vim.fn.strdisplaywidth(vim.api.nvim_buf_get_text(0, end_pos[1] - 1, 0, end_pos[1] - 1, end_pos[2], {})[1])
		local left_vc = math.min(start_dw, end_dw) + 1
		local right_vc = math.max(start_vc, end_vc)
		local vc = type == "i" and left_vc or (right_vc + 1)

		local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
		local start = start_pos[1] == cursor_row and start_pos[1] or end_pos[1]
		local endl = start_pos[1] == cursor_row and end_pos[1] or start_pos[1]
		local dir = start_pos[1] == cursor_row and 1 or -1
		for lnum = start, endl, dir do
			local bc = vim.fn.virtcol2col(0, lnum, vc - 1)
			local text = vim.api.nvim_buf_get_text(0, lnum - 1, 0, lnum - 1, bc, {})[1]
			local dw = vim.fn.strdisplaywidth(text)
			if dw >= vc then
				text = vim.fn.strcharpart(text, 0, vim.fn.strchars(text, 1) - 1)
				bc = #text
				dw = vim.fn.strdisplaywidth(text)
			end
			local padding = vc - dw - 1
			if padding > 0 then
				vim.api.nvim_buf_set_text(0, lnum - 1, bc, lnum - 1, bc, { string.rep(" ", padding) })
			end
			bc = bc + padding
			if lnum == cursor_row then
				vim.api.nvim_win_set_cursor(0, { lnum, bc })
			else
				require("multiple-cursors").add_cursor(lnum, bc + 1, vc)
			end
		end
		vim.api.nvim_input("i")
	end
end

local function add_cursors_in_flash()
	local selected_cursors = require("user.motion").flash_select()
	-- schedule to avoid the <esc> be consumed by multiple-cursors when exit flash
	vim.schedule(function()
		local once = true
		for _, pos in pairs(selected_cursors) do
			if once then
				once = false
				vim.api.nvim_win_set_cursor(0, pos)
			else
				local vc =
					vim.fn.strdisplaywidth(vim.api.nvim_buf_get_text(0, pos[1] - 1, 0, pos[1] - 1, pos[2], {})[1])
				require("multiple-cursors").add_cursor(pos[1], pos[2] + 1, vc)
			end
		end
	end)
end

local function config_normal() end

local function config_undo() end

local function config_visual_selection() end

local function config_multiple_cursor() end

M.config = function()
	------------------
	-- Text Object
	------------------
	lvim.builtin.treesitter.textobjects = {
		select = {
			enable = true,
			keymaps = {
				["i,"] = "@parameter.inner",
				["a,"] = "@parameter.outer",
				["ib"] = "@block.inner",
				["ab"] = "@block.outer",
				["if"] = "@function.inner",
				["af"] = "@function.outer",
				["ic"] = "@class.inner",
				["ac"] = "@class.outer",
			},
		},
		move = {
			enable = true,
			goto_next_start = {
				["]]"] = { query = "@scope", query_group = "locals", desc = "Next scope start" },
				["]m"] = "@function.outer",
			},
			goto_next_end = {
				["]["] = { query = "@scope", query_group = "locals", desc = "Next scope end" },
				["]M"] = "@function.outer",
			},
			goto_previous_start = {
				["[["] = { query = "@scope", query_group = "locals", desc = "Previous scope start" },
				["[m"] = "@function.outer",
			},
			goto_previous_end = {
				["[]"] = { query = "@scope", query_group = "locals", desc = "Previous scope end" },
				["[M"] = "@function.outer",
			},
		},
	}
	table.insert(lvim.plugins, {
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	})

	------------------
	-- Normal Edit
	------------------
	table.insert(lvim.plugins, {
		"kylechui/nvim-surround",
		keys = {
			{ "ds", mode = "n" },
			{ "cs", mode = "n" },
			{ "cS", mode = "n" },
			{ "ys", mode = "n" },
			{ "yss", mode = "n" },
			{ "yS", mode = "n" },
			{ "ySS", mode = "n" },
			{ "S", mode = "x" },
			{ "gS", mode = "x" },
			{ "<C-g>s", mode = "i" },
			{ "<C-g>S", mode = "i" },
		},
		opts = {},
	})

	keymap("n", "<", "<<")
	keymap("n", ">", ">>")

	------------------
	-- Undo
	------------------
	table.insert(lvim.plugins, {
		"tzachar/highlight-undo.nvim",
		keys = { "u", "<C-r>" },
		opts = {
			duration = 100,
			undo = { hlgroup = "Search" },
			redo = { hlgroup = "Search" },
		},
	})

	lvim.builtin.telescope.extensions.undo = {
		side_by_side = true,
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
			height = 0.8,
			width = 0.8,
			preview_width = 0.65,
		},
	}
	table.insert(lvim.plugins, {
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = { { "<Space>u", "<Cmd>Telescope undo<CR>", desc = "Undo History" } },
		config = function()
			require("telescope").load_extension("undo")
		end,
		cond = not vim.g.vscode,
	})

	------------------
	-- Visual Selection
	------------------
	lvim.builtin.treesitter.incremental_selection = {
		enable = true,
		keymaps = {
			node_incremental = "v",
			node_decremental = "V",
		},
	}

	------------------
	-- Multiple Cursors
	------------------
	table.insert(lvim.plugins, {
		"brenton-leighton/multiple-cursors.nvim",
		keys = {
			{ "<M-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>" },
			{
				"mc/",
				add_cursors_in_flash,
			},
			{
				"m",
				function()
					add_cursors_in_visual("")
				end,
				mode = "x",
			},
			{
				"I",
				function()
					add_cursors_in_visual("i")
				end,
				mode = "x",
			},
			{
				"A",
				function()
					add_cursors_in_visual("a")
				end,
				mode = "x",
			},
			{
				"c",
				function()
					add_cursors_in_visual("c")
				end,
				mode = "x",
			},
		},
		opts = {
			disabled_default_key_maps = {
				{ "n", { "<<", ">>" } },
			},
			custom_key_maps = {
				{
					"n",
					"<",
					function()
						require("multiple-cursors.normal_edit").indent()
					end,
				},
				{
					"n",
					">",
					function()
						require("multiple-cursors.normal_edit").deindent()
					end,
				},
				{
					"n",
					"S",
					function()
						require("multiple-cursors.normal_to_insert").i()
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "x", false)
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
					end,
				},
				{
					"n",
					"ds",
					function(char)
						require("nvim-surround") -- load surround if it is lazy
						vim.cmd([[exe "normal \<Plug>(nvim-surround-delete)]] .. char .. '"')
					end,
					"c",
				},
				{
					"n",
					"cs",
					function(char1, char2)
						require("nvim-surround") -- load surround if it is lazy
						vim.cmd([[exe "normal \<Plug>(nvim-surround-change)]] .. char1 .. char2 .. '"')
					end,
					"cc",
				},
			},
		},
		cond = not vim.g.vscode,
	})

	table.insert(lvim.plugins, { "vscode-neovim/vscode-multi-cursor.nvim", cond = vim.g.vscode })

	-- insert mode
	keymap("i", "<C-h>", "<Left>")
	keymap("i", "<C-l>", "<Right>")
	keymap("c", "<C-a>", "<C-b>")

	keymap("i", "<C-h>", "<Left>")
	keymap("i", "<C-l>", "<Right>")
	keymap("i", "<C-a>", "<C-g>u<Cmd>normal! ^<CR>")
	keymap("i", "<C-e>", "<C-g>u<End>")
	keymap("i", "<C-w>", "<C-g>u<C-w>")
	keymap("i", "<C-u>", "<C-g>u<C-u>")
	keymap("i", "<C-k>", function()
		local len = #vim.api.nvim_get_current_line()
		local pos = vim.api.nvim_win_get_cursor(0)
		if pos[2] < len then
			vim.api.nvim_buf_set_text(0, pos[1] - 1, pos[2], pos[1] - 1, len, {})
		end
	end)
	keymap("c", "<C-k>", function()
		local text = vim.fn.getcmdline()
		local col = vim.fn.getcmdpos()
		vim.fn.setcmdline(text:sub(1, col - 1))
	end)
	keymap("n", "<C-j>", "<Cmd>put =repeat(nr2char(10), v:count1)<CR>")
	keymap("i", "<C-j>", "<End><CR>")
	keymap("i", "<C-z>", "<Cmd>undo<CR>")

	-- others
	lvim.builtin.treesitter.autotag = { enable = true }
	table.insert(lvim.plugins, {
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cond = not vim.g.vscode,
	})
end

return M
