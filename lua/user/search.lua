local M = {}

local keymap = require("user.which-key").keymap

-- Simulate vsocde find shortcuts
local function toggle_search_pattern(flag)
	local t = vim.fn.getcmdtype()
	if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "c" and t ~= "/" and t ~= "?" then
		return
	end

	local pattern = vim.fn.getcmdline()
	if pattern:sub(1, 1) == t then
		return
	end

	local flag_w1, flag_w2, flag_c, flag_r
	local flag_end
	local i = 1
	while i <= #pattern do
		local c = pattern:sub(i, i)
		if flag_end then
			if c == "\\" then
				i = i + 1
				if i > #pattern then
					break
				end
				local c2 = pattern:sub(i, i)
				if c2 == ">" and not flag_r and i == #pattern then
					flag_w2 = true
				end
			else
				if c == ">" and flag_r and i == #pattern then
					flag_w2 = true
				end
			end
			goto continue
		end

		if c == "\\" then
			i = i + 1
			if i > #pattern then
				break
			end
			local c2 = pattern:sub(i, i)
			if c2 == "<" and not flag_r then
				flag_w1 = true
			elseif c2 == "C" then
				flag_c = true
			elseif c2 == "v" then
				flag_r = true
			else
				flag_end = i - 1
				i = i - 2
			end
		else
			if c == "<" and flag_r then
				flag_w1 = true
			else
				flag_end = i
				i = i - 1
			end
		end

		::continue::
		i = i + 1
	end

	local w2_len
	if flag_w2 then
		w2_len = flag_r and 1 or 2
	else
		w2_len = 0
	end

	pattern = flag_end and pattern:sub(flag_end, #pattern - w2_len) or ""
	if flag == "w" and (not flag_w1 or not flag_w2) or flag ~= "w" and flag_w1 and flag_w2 then
		w2_len = flag_r and 1 or 2
		pattern = (flag_r and "<" or "\\<") .. pattern .. (flag_r and ">" or "\\>")
	else
		w2_len = 0
	end
	if flag == "c" and not flag_c or flag ~= "c" and flag_c then
		pattern = "\\C" .. pattern
	end
	if flag == "r" and not flag_r or flag ~= "r" and flag_r then
		pattern = "\\v" .. pattern
	end

	vim.fn.setcmdline(pattern, #pattern + 1 - w2_len)
	-- To trigger flash update
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(" <BS>", true, false, true), "n", false)
end

local function toggle_telescope_search_arg(bufnr, arg, quote)
	arg = arg or ""
	quote = quote or ""
	local picker = require("telescope.actions.state").get_current_picker(bufnr)
	local prompt = picker:_get_prompt()
	local prompt_words = require("telescope-live-grep-args.prompt_parser").parse(prompt)
	local arg_words = {}
	local pattern_words = {}
	local is_pat = false
	for _, word in ipairs(prompt_words) do
		if not is_pat and word:find("-", 1, true) == 1 then
			table.insert(arg_words, word)
		else
			is_pat = true
			table.insert(pattern_words, word)
		end
	end
	if #arg > 0 then
		local arg_pos
		for i, a in ipairs(arg_words) do
			if a == arg then
				arg_pos = i
			end
		end
		if arg_pos then
			table.remove(arg_words, arg_pos)
		else
			table.insert(arg_words, arg)
		end
	end
	local pattern = table.concat(pattern_words, " ")
	local quote_len = #quote
	if quote_len > 0 then
		if
			pattern:find(quote, 1, true) == 1
			and pattern:find(quote, #pattern - quote_len + 1, true) == #pattern - quote_len + 1
		then
			pattern = pattern:sub(quote_len + 1, #pattern - quote_len)
		else
			pattern = quote .. pattern .. quote
		end
	end
	local new_prompt = table.concat(arg_words, " ") .. (#arg_words > 0 and " " or "") .. pattern
	picker:set_prompt(new_prompt)
end

M.config = function()
	------------------
	-- Search Mode
	------------------
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.shortmess = "oOtTIcCFS" -- show message when search hit top or bottom

	table.insert(lvim.plugins, {
		"kevinhwang91/nvim-hlslens",
		event = "CmdlineEnter",
		keys = {
			{
				"n",
				[[<Cmd>execute("normal! " . v:count1 . "Nn"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
				desc = "Repeat last search in forward direction",
			},
			{
				"N",
				[[<Cmd>execute("normal! " . v:count1 . "nN"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
				desc = "Repeat last search in backward direction",
			},
			{
				"*",
				[[*<Cmd>lua require("hlslens").start()<CR>]],
				desc = "Search forward for nearest word (match word)",
			},
			{
				"#",
				[[#<Cmd>lua require("hlslens").start()<CR>]],
				desc = "Search forward for nearest word (match word)",
			},
			{
				"g*",
				[[g*<Cmd>lua require("hlslens").start()<CR>]],
				desc = "Search forward for nearest word",
			},
			{
				"g#",
				[[g#<Cmd>lua require("hlslens").start()<CR>]],
				desc = "Search backward for nearest word",
			},
		},
		opts = {
			calm_down = true,
			override_lens = function(render, posList, nearest, idx, relIdx)
				local sfw = vim.v.searchforward == 1
				local indicator, text, chunks
				local absRelIdx = math.abs(relIdx)
				if absRelIdx > 1 then
					indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
				elseif absRelIdx == 1 then
					indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
				else
					indicator = ""
				end
				local lnum, col = unpack(posList[idx])
				if nearest then
					local cnt = #posList
					if indicator ~= "" then
						text = ("[%s %d/%d]"):format(indicator, idx, cnt)
					else
						text = ("[%d/%d]"):format(idx, cnt)
					end
					chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
				else
					text = ("[%s %d]"):format(indicator, idx)
					chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
				end
				render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
			end,
		},
		config = function(_, opts)
			require("hlslens").setup(opts)
			if vim.g.vscode then
				-- To clear and redraw in vscode
				require("hlslens.lib.event"):on("LensUpdated", function()
					vim.cmd("mode")
				end, {})
				-- TODO: colorscheme
				vim.cmd("hi HlSearchLensNear guibg=#40bf6a guifg=#062e32")
				vim.cmd("hi HlSearchLens guibg=#0a5e69 guifg=#b2cac3")
			end
		end,
	})

	keymap("c", "<M-w>", function()
		toggle_search_pattern("w")
	end, { desc = "Match whole word" })
	keymap("c", "<M-c>", function()
		toggle_search_pattern("c")
	end, { desc = "Match case" })
	keymap("c", "<M-r>", function()
		toggle_search_pattern("r")
	end, { desc = "Use very magic" })

	------------------
	-- Telescope
	------------------
	lvim.builtin.telescope.defaults.winblend = 15
	lvim.builtin.telescope.defaults.layout_config = {
		center = {
			anchor = "N",
			width = 0.6,
		},
	}
	lvim.builtin.telescope.defaults.mappings = {
		i = {
			["<Esc>"] = function(bufnr)
				require("telescope.actions").close(bufnr)
			end,
			["<M-w>"] = function(bufnr)
				toggle_telescope_search_arg(bufnr, "", "\\b")
			end,
			["<M-c>"] = function(bufnr)
				toggle_telescope_search_arg(bufnr, "-s")
			end,
			["<M-r>"] = function(bufnr)
				toggle_telescope_search_arg(bufnr, "-F")
			end,
		},
	}
	lvim.builtin.telescope.on_config_done = function()
		keymap("n", "<C-S-O>", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Search symbols in file" })
		keymap("n", "<C-t>", "<Cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Search symbols in workspace" })
		keymap("n", "<C-p>", "<Cmd>Telescope find_files hidden=true<CR>", { desc = "Search files in workspace" })
		keymap("n", "<C-k>r", "<Cmd>Telescope oldfiles<CR>", { desc = "Search recently opened files" })
		keymap("n", "m/", "<Cmd>Telescope marks<CR>", { desc = "Search marks" })
	end

	table.insert(lvim.plugins, {
		"nvim-telescope/telescope-live-grep-args.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{
				"<C-S-F>",
				function()
					require("telescope").extensions.live_grep_args.live_grep_args()
				end,
				mode = "n",
        desc = "Search text in workspace"
			},
			{
				"<C-S-F>",
				function()
					require("telescope-live-grep-args.shortcuts").grep_visual_selection({
						postfix = "",
						quote = false,
					})
				end,
				mode = "x",
        desc = "Search text in workspace"
			},
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
		cond = not vim.g.vscode,
	})

	table.insert(lvim.plugins, {
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
			keymap("n", "<Space>t", "<Cmd>TodoTrouble<CR>", { desc = "TODOs" })
		end,
		cond = not vim.g.vscode,
	})
end

return M
