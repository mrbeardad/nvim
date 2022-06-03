local M = {}

M.config = function()
	vim.cmd([[hi link BookmarkSign TodoFgTodo]])
	vim.cmd([[hi link BookmarkAnnotationSign TodoFgTodo]])
end

return M
