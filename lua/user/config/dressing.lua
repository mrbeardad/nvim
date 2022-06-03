local M = {}

M.config = function()
	require("dressing").setup({
		input = {
			get_config = function()
				if vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree" then
					return { enabled = false }
				end
			end,
		},
		select = {
			format_item_override = {
				codeaction = function(action_tuple)
					local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
					local client = vim.lsp.get_client_by_id(action_tuple[1])
					return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
				end,
			},
		},
	})
end

return M
