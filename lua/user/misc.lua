local M = {}

local keymap = require("user.which-key").keymap

M.config = function()
	vim.opt.swapfile = true
	vim.opt.directory = join_paths(get_cache_dir(), "swap") .. "//"
	vim.opt.confirm = true

	keymap("n", "<C-S-P>", "<Cmd>Telescope builtin<CR>")
	keymap("n", "<M-z>", "<Cmd>let &wrap=!&wrap<CR>")
	keymap("n", "<M-e>", function()
		local documentation_url = vim.fn.expand("%:p:h")
		if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
			vim.fn.execute("!open " .. documentation_url)
		elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
			vim.fn.execute("!start " .. documentation_url)
		elseif vim.fn.has("unix") == 1 then
			vim.fn.execute("!xdg-open " .. documentation_url)
		else
			vim.notify("Opening docs in a browser is not supported on your OS")
		end
	end)
end

return M
