local M = {}

M.config = function()
	local disabled_plugins = {
		"2html_plugin",
		"getscript",
		"getscriptPlugin",
		"gzip",
		"logipat",
		"netrw",
		"netrwPlugin",
		"netrwSettings",
		"netrwFileHandlers",
		"matchit",
		"tar",
		"tarPlugin",
		"rrhelper",
		"spellfile_plugin",
		"vimball",
		"vimballPlugin",
		"zip",
		"zipPlugin",
	}
	for _, plugin in pairs(disabled_plugins) do
		vim.g["loaded_" .. plugin] = 1
	end

	vim.opt.backup = true
	vim.opt.backupdir = join_paths(get_cache_dir(), "backup")
	vim.opt.swapfile = true
	vim.opt.updatetime = 250
	vim.opt.directory = join_paths(get_cache_dir(), "swap")
	vim.opt.list = true
	vim.opt.listchars = "tab:→ ,eol:↵,trail:·,extends:↷,precedes:↶"
	vim.opt.wildignorecase = true
	vim.opt.colorcolumn = "100"
	vim.opt.relativenumber = true
	vim.opt.clipboard = ""
	vim.opt.completeopt = { "menu", "menuone", "noselect" }
	vim.opt.diffopt = {
		"internal",
		"filler",
		"closeoff",
		"hiddenoff",
		"algorithm:minimal",
	}
	vim.opt.timeoutlen = 250
	vim.opt.ttimeoutlen = 10
	vim.opt.redrawtime = 1500

	vim.wo.foldmethod = "expr"
	vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
	vim.wo.foldlevel = 4
	vim.wo.foldtext =
		[[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
	vim.wo.foldnestmax = 3
	vim.wo.foldminlines = 1

	vim.opt.pumblend = 10
	vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
	if vim.fn.has("nvim-0.7") ~= 0 then
		vim.opt.fillchars = {
			fold = " ",
			eob = " ", -- suppress ~ at EndOfBuffer
			diff = "╱", -- alternatives = ⣿ ░ ─
			msgsep = "‾",
			foldopen = "▾",
			foldsep = "│",
			foldclose = "▸",
			horiz = "━",
			horizup = "┻",
			horizdown = "┳",
			vert = "┃",
			vertleft = "┫",
			vertright = "┣",
			verthoriz = "╋",
		}
	else
		vim.opt.fillchars = {
			vert = "▕", -- alternatives │
			fold = " ",
			eob = " ", -- suppress ~ at EndOfBuffer
			diff = "╱", -- alternatives = ⣿ ░ ─
			msgsep = "‾",
			foldopen = "▾",
			foldsep = "│",
			foldclose = "▸",
		}
	end
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
	vim.opt.shortmess = {
		t = true, -- truncate file messages at start
		A = true, -- ignore annoying swap file messages
		o = true, -- file-read message overwrites previous
		O = true, -- file-read message overwrites previous
		T = true, -- truncate non-file messages in middle
		f = true, -- (file x of x) instead of just (x of x
		F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
		s = true,
		c = true,
		W = true, -- Don't show [w] or written when writing
	}

	-- Cursorline highlighting control
	--  Only have it on in the active buffer
	vim.opt.cursorline = true -- Highlight the current line
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
	vim.opt.guifont = "NerdCodePro Font:h13"
	if vim.g.neovide then
		vim.g.neovide_cursor_animation_length = 0.01
		vim.g.neovide_cursor_trail_length = 0.05
		vim.g.neovide_cursor_antialiasing = true
		vim.g.neovide_remember_window_size = true
		vim.g.neovide_cursor_vfx_mode = "ripple"
	end
	if vim.g.nvui then
		-- Configure nvui here
		vim.cmd([[NvuiCmdFontFamily FiraCode Nerd Font]])
		vim.cmd([[set linespace=1]])
		vim.cmd([[set guifont=FiraCode\ Nerd\ Font:h14]])
		vim.cmd([[NvuiPopupMenuDefaultIconFg white]])
		vim.cmd([[NvuiCmdBg #1e2125]])
		vim.cmd([[NvuiCmdFg #abb2bf]])
		vim.cmd([[NvuiCmdBigFontScaleFactor 1.0]])
		vim.cmd([[NvuiCmdPadding 10]])
		vim.cmd([[NvuiCmdCenterXPos 0.5]])
		vim.cmd([[NvuiCmdTopPos 0.0]])
		vim.cmd([[NvuiCmdFontSize 20.0]])
		vim.cmd([[NvuiCmdBorderWidth 5]])
		vim.cmd([[NvuiPopupMenuIconFg variable #56b6c2]])
		vim.cmd([[NvuiPopupMenuIconFg function #c678dd]])
		vim.cmd([[NvuiPopupMenuIconFg method #c678dd]])
		vim.cmd([[NvuiPopupMenuIconFg field #d19a66]])
		vim.cmd([[NvuiPopupMenuIconFg property #d19a66]])
		vim.cmd([[NvuiPopupMenuIconFg module white]])
		vim.cmd([[NvuiPopupMenuIconFg struct #e5c07b]])
		vim.cmd([[NvuiCaretExtendTop 15]])
		vim.cmd([[NvuiCaretExtendBottom 8]])
		vim.cmd([[NvuiTitlebarFontSize 12]])
		vim.cmd([[NvuiTitlebarFontFamily Arial]])
		vim.cmd([[NvuiCursorAnimationDuration 0.1]])
		-- vim.cmd [[NvuiToggleFrameless]]
		vim.cmd([[NvuiOpacity 0.99]])
	end
end

return M
