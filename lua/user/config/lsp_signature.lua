local M = {}

M.config = function()
	local attach = require("lvim.lsp").common_on_attach
	require("lvim.lsp").common_on_attach = function(client, bufnr)
		require("lsp_signature").on_attach({
			doc_lines = 10,
			floating_window = true,
			floating_window_above_cur_line = false,
			hint_enable = false,
			hint_prefix = " ",
			extra_trigger_chars = { "(", "," }, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
			-- zindex = 1002, -- by default it will be on top of all floating windows, set to 50 send it to bottom
			toggle_key = "<C-s>",
		})
		attach(client, bufnr)
	end
end

return M
