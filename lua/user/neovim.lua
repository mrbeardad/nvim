local M = {}

M.config = function()
	vim.opt.backup = true
	vim.opt.backupdir = join_paths(get_cache_dir(), "backup")
	vim.opt.swapfile = true
	vim.opt.directory = join_paths(get_cache_dir(), "swap")
	vim.opt.updatetime = 250
	vim.opt.list = true
	vim.opt.listchars = "tab:→ ,eol:↵,trail:·,extends:↷,precedes:↶"
	vim.opt.wildignorecase = true
	vim.opt.colorcolumn = "100"
	vim.opt.relativenumber = true
	vim.opt.clipboard = ""
	vim.opt.timeoutlen = 250
	vim.opt.ttimeoutlen = 10
	vim.opt.redrawtime = 1500
	vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
	vim.opt.wildignore = {
		"*.aux,*.out,*.toc",
		"*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
		-- media
		"*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
		"*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
		"*.eot,*.otf,*.ttf,*.woff",
		"*.doc,*.pdf",
		-- archives
		"*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
		-- temp/system
		"*.*~,*~ ",
		"*.swp,.lock,.DS_Store,._*,tags.lock",
		-- version control
		".git,.svn",
	}

	-- Cursorline highlighting control, only have it on in the active buffer
	vim.opt.cursorline = true
	if vim.fn.has("nvim-0.7") ~= 0 then
		local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
		vim.api.nvim_create_autocmd("WinLeave", {
			group = group,
			callback = function()
				vim.opt_local.cursorline = false
			end,
		})
		vim.api.nvim_create_autocmd("WinEnter", {
			group = group,
			callback = function()
				if vim.bo.filetype ~= "alpha" then
					vim.opt_local.cursorline = true
				end
			end,
		})
	end

	vim.opt.guicursor = "n:block-blinkon10,i-ci:ver15-blinkon10,c:hor15-blinkon10,v-sm:block,ve:ver15,r-cr-o:hor10"
end

return M
