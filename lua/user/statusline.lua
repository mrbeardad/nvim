local M = {}

M.config = function()
	lvim.builtin.lualine.options = {
		globalstatus = true,
		section_separators = { left = "", right = "" },
	}

	local components = require("lvim.core.lualine.components")
	lvim.builtin.lualine.sections.lualine_a = {
		{
			" ",
			type = "stl",
			-- color = { fg = "#b3e1a3" },
		},
		-- {
		-- 	"",
		-- 	type = "stl",
		-- 	color = { fg = "#e697a7" },
		-- },
		-- {
		-- 	"",
		-- 	type = "stl",
		-- 	color = { fg = "#a4b9ef" },
		-- },
	}
	lvim.builtin.lualine.sections.lualine_b = {
		{
			function()
				return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			end,
		},
		components.branch,
	}
	lvim.builtin.lualine.sections.lualine_c = {
		{
			function()
				if not vim.bo.readonly or not vim.bo.modifiable then
					return ""
				end
				return "" -- """
			end,
			color = { fg = "#f7768e" },
		},
		components.diff,
		components.python_env,
	}
	lvim.builtin.lualine.sections.lualine_x = {
		components.diagnostics,
	}
	lvim.builtin.lualine.sections.lualine_y = {
		components.treesitter,
		{
			function(msg)
				msg = msg or "LS Inactive"
				local buf_clients = vim.lsp.buf_get_clients()
				if next(buf_clients) == nil then
					if type(msg) == "boolean" or #msg == 0 then
						return "[LS Inactive]"
					end
					return msg
				end
				local buf_ft = vim.bo.filetype
				local buf_client_names = {}

				-- add client
				for _, client in pairs(buf_clients) do
					if client.name ~= "null-ls" then
						table.insert(buf_client_names, client.name)
					end
				end

				-- add formatter
				local formatters = require("lvim.lsp.null-ls.formatters")
				local supported_formatters = formatters.list_registered(buf_ft)
				vim.list_extend(buf_client_names, supported_formatters)

				-- add linter
				local linters = require("lvim.lsp.null-ls.linters")
				local supported_linters = linters.list_registered(buf_ft)
				vim.list_extend(buf_client_names, supported_linters)

				return table.concat(buf_client_names, ", ")
			end,
			icon = { " ", color = { fg = "#ddd" } },
			cond = require("lvim.core.lualine.conditions").hide_in_width,
		},
		components.filetype,
		{ "fileformat", color = { fg = "#c2e7f0" } },
	}
	lvim.builtin.lualine.sections.lualine_z = {
		{
			function()
				local function format_file_size(file)
					local size = vim.fn.getfsize(file)
					if size <= 0 then
						return ""
					end
					local sufixes = { "B", "K", "M", "G" }
					local i = 1
					while size > 1024 do
						size = size / 1024
						i = i + 1
					end
					local fmt = "%.1f%s"
					if i == 1 then
						fmt = "%d%s"
					end
					return string.format(fmt, size, sufixes[i])
				end

				local file = vim.fn.expand("%:p")
				if string.len(file) == 0 then
					return ""
				end
				return format_file_size(file)
			end,
			cond = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
		},
		{ " %l/%L  %c", type = "stl" },
		components.scrollbar,
	}
end

return M
