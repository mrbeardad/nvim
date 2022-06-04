local M = {}

M.setup = function()
	vim.g.matchup_surround_enabled = 1
	vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

return M
