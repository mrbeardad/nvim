local M = {}

M.config = function()
	vim.cmd([[hi link BookmarkSign TodoSignTODO]])
	vim.cmd([[hi link BookmarkAnnotationSign TodoSignTODO]])
end

return M
