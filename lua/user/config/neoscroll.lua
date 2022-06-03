local M = {}

M.config = function()
	require("neoscroll").setup({
		mappings = { "<C-d>", "<C-u>", "<C-b>", "zt", "zz", "zb" },
		respect_scrolloff = true,
		easing_function = "quadratic",
	})
end

return M
