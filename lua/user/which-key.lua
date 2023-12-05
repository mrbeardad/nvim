local M = {}

local which_key_mappings = {}

M.keymap = function(mode, lhs, rhs, opts, req)
	opts = opts or {}

	-- if vim.g.vscode then
	-- 	vim.keymap.set(mode, lhs, rhs, opts)
	-- 	return
	-- end

	-- if req then
	-- 	opts.mode = mode
	-- 	if type(rhs) == "table" and rhs.name then
	-- 		require("which-key").register({ [lhs] = rhs }, opts)
	-- 	else
	-- 		require("which-key").register({ [lhs] = { rhs, opts.desc or "" } }, opts)
	-- 	end
	-- 	return
	-- end

	-- local prefix = { "<leader>", "<space>", "g", "z", "m", "[", "]", "<c-w>" }
	-- for _, p in ipairs(prefix) do
	-- 	if lhs:lower():find(p, 1, true) then
	-- 		opts.mode = mode
	-- 		if type(rhs) == "table" and rhs.name then
	-- 			table.insert(which_key_mappings, { { [lhs] = rhs }, opts })
	-- 		else
	-- 			table.insert(which_key_mappings, { { [lhs] = { rhs, opts.desc or "" } }, opts })
	-- 		end
	-- 		return
	-- 	end
	-- end

	vim.keymap.set(mode, lhs, rhs, opts)
end

M.config = function()
	lvim.builtin.which_key.setup.ignore_missing = false
	lvim.builtin.which_key.setup.plugins.marks = true
	lvim.builtin.which_key.setup.plugins.registers = true
	lvim.builtin.which_key.setup.plugins.presets = {
		operators = false,
		motions = true,
		text_objects = true,
		windows = true,
		nav = true,
		z = true,
		g = true,
	}

	lvim.builtin.which_key.setup.operators = {
		["d"] = "Delete",
		["c"] = "Change",
		["y"] = "Yank",
		["v"] = "Visual Character Mode",
		["gu"] = "Lowercase",
		["gU"] = "Uppercase",
		["g~"] = "Toggle case",
		["!"] = "Filter through external program",
		["zf"] = "Create fold",
	}

	require("which-key.plugins.presets").objects = {
		a = { name = "around" },
		i = { name = "inside" },
		["aw"] = [[a word]],
		["iw"] = [[inner word]],
		["aW"] = [[a WORD]],
		["iW"] = [[inner WORD]],
		["as"] = [[a sentence]],
		["is"] = [[inner sentence]],
		["ap"] = [[a paragraph]],
		["ip"] = [[inner paragraph]],
		["a{"] = [[a {} block]],
		["i{"] = [[inner {} block]],
		["a["] = [[a [] block]],
		["i["] = [[inner [] block]],
		["a("] = [[a () block]],
		["i("] = [[inner () block]],
		["a<"] = [[a <> block]],
		["i<"] = [[inner <> block]],
		["at"] = [[a <tag></tag> block]],
		["it"] = [[inner <tag></tag> block]],
		['a"'] = [[a "quoted string"]],
		["a'"] = [[a 'quoted string']],
		["a`"] = [[a `quoted string`]],
		['i"'] = [[a "quoted string" without the quotes]],
		["i'"] = [[a 'quoted string' without the quotes]],
		["i`"] = [[a `quoted string` without the quotes]],
		["a,"] = [[a parameter, ... (with comma)]],
		["i,"] = [[inner parameter, ... (without comma)]],
		["ab"] = [[a block scope]],
		["ib"] = [[inner block scope]],
		["af"] = [[a function scope]],
		["if"] = [[inner function scope]],
		["ac"] = [[a class scope]],
		["ic"] = [[inner class scope]],
	}

	lvim.builtin.which_key.mappings["/"] = nil
	lvim.builtin.which_key.mappings["f"] = nil
	lvim.builtin.which_key.mappings["h"] = nil
	lvim.builtin.which_key.mappings["w"] = nil

	lvim.builtin.which_key.on_config_done = function(which_key)
		for _, mapping in pairs(which_key_mappings) do
			which_key.register(mapping[1], mapping[2])
		end
	end
end

return M
