local M = {}

M.config = function()
	local components = require("lvim.core.lualine.components")
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
				return ""
			end,
			color = { fg = "#f7768e" },
		},
		components.diff,
		components.python_env,
	}
	lvim.builtin.lualine.sections.lualine_x = {
		components.diagnostics,
	}
	components.lsp.icon = { " ", color = { fg = "#ddd" } }
	lvim.builtin.lualine.sections.lualine_y = {
		components.treesitter,
		components.lsp,
		components.spaces,
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
