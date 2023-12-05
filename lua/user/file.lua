local M = {}

local keymap = require("user.which-key").keymap

local function toggle_explorer()
	local winnr = require("nvim-tree.view").get_winnr()
	if not winnr or not vim.api.nvim_win_is_valid(winnr) then
		require("nvim-tree.api").tree.toggle({ focus = false })
		vim.cmd("SymbolsOutlineOpen")
	elseif vim.api.nvim_get_current_win() == winnr then
		require("nvim-tree.api").tree.close()
		vim.cmd("SymbolsOutlineClose")
	else
		require("nvim-tree.api").tree.focus()
	end
end

local function switch_window(next)
	return function()
		local cur_win = vim.api.nvim_get_current_win()
		local wins = vim.api.nvim_tabpage_list_wins(0)
		local start
		local idx = 0
		local step = next and 1 or -1
		while true do
			local win = wins[idx + 1]
			idx = (idx + step) % #wins
			if not start then
				start = win == cur_win
			else
				if win == cur_win then
					return
				end
				local bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "buftype")
				if bt ~= "nofile" then
					vim.api.nvim_set_current_win(win)
					return
				end
			end
		end
	end
end

local function smart_quit()
	local cur_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local bt = vim.api.nvim_buf_get_option(buf, "buftype")
		if bt ~= "nofile" and bt ~= "quickfix" and win ~= cur_win then
			vim.cmd("confirm q")
			return
		end
	end
	-- quit if all other windows are not normal window
	vim.cmd("confirm qa")
end

M.config = function()
	lvim.builtin.nvimtree.setup.view.preserve_window_proportions = true
	lvim.builtin.nvimtree.setup.on_attach = function(bufnr)
		local api = require("nvim-tree.api")
		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end
		api.config.mappings.default_on_attach(bufnr)
		vim.keymap.del("n", "<Tab>", { buffer = bufnr })
		keymap("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
		keymap("n", "l", api.node.open.edit, opts("Open"))
	end
	keymap("n", "<Space>e", toggle_explorer, { desc = "Explorer" })

	keymap("n", "H", "<Cmd>BufferLineCyclePrev<CR>")
	keymap("n", "L", "<Cmd>BufferLineCycleNext<CR>")
	-- keymap("n", "<Space><Tab>", "<Cmd>try<Bar>b#<Bar>catch<Bar>endtry<CR>", { desc = "Switch buffer" })
	keymap("n", "<Space><Tab>", function()
		require("telescope.builtin").buffers({ sort_lastused = true, initial_mode = "insert" })
	end, { desc = "Switch buffer" })
	keymap("n", "<C-s>", "<Cmd>w<CR>")
	keymap("n", "<C-S-S>", ':saveas <C-r>=fnamemodify(".",":p")<CR>')
	keymap("n", "<Space>bc", "<Cmd>BufferKill<CR>", { desc = "Close" })

	keymap("n", "<Tab>", switch_window(true))
	keymap("n", "<S-Tab>", switch_window())
	keymap("n", "<Space>q", smart_quit, { desc = "Quit" })
end

return M
