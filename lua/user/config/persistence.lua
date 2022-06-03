local M = {}

M.config = function()
	require("persistence").setup({
		dir = join_paths(get_cache_dir(), "session/"),
		options = { "buffers", "curdir", "tabpages", "winsize" },
	})
end

return M
