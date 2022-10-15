local M = {}

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.config = function()
	--------------
	-- 屏幕滚动 --
	--------------
	-- plugin: neoscroll.nvim

	--------------
	-- 光标移动 --
	--------------
	-- plugin: clever-f.vim
	-- plugin: hop.nvim
	-- plugin: vim-matchup
	map("c", "<C-a>", "<C-b>", { noremap = true })
	map("", ";", "<CMD>HopChar2<CR>")
	map("", ",", "<CMD>HopLineStartMW<CR>")

	--------------
	-- 标签跳转 --
	--------------
	-- plugin: nvim-lastplace
	-- plugin: vim-bookmarks
	-- plugin: telescope-vim-bookmarks
	-- HACK: terminal map: ctrl+i -> alt+shift+i
	map("n", "<M-I>", "<C-i>")
	map("n", "mm", "<Plug>BookmarkToggle", { noremap = false })
	map("n", "mi", "<Plug>BookmarkAnnotate", { noremap = false })
	map("n", "mn", "<Plug>BookmarkNext", { noremap = false })
	map("n", "mp", "<Plug>BookmarkPrev", { noremap = false })
	map("n", "mc", "<Plug>BookmarkClear", { noremap = false })
	map("n", "mC", "<Plug>BookmarkClearAll", { noremap = false })
	map("n", "mjj", "<Plug>BookmarkMoveDown", { noremap = false })
	map("n", "mkk", "<Plug>BookmarkMoveUp", { noremap = false })
	map("n", "mg", "<Plug>BookmarkMoveToLine", { noremap = false })
	map("n", "]g", "<CMD>Gitsigns next_hunk<CR>")
	map("n", "[g", "<CMD>Gitsigns prev_hunk<CR>")

	--------------
	-- 全文搜索 --
	--------------
	-- plugin: vim-visual-star-search
	-- plugin: vim-cool
	-- plugin: telescope-live-grep-raw.nvim
	-- plugin: nvim-spectre
	map("n", "n", "'Nn'[v:searchforward]", { expr = true })
	map("n", "N", "'nN'[v:searchforward]", { expr = true })
	map("n", "<C-l>", "<CMD>nohl<CR><C-l>")
	map("c", "<M-W>", "\\<\\><Left><Left>")
	map("c", "<M-r>", "\\v")
	map("c", "<M-c>", "\\C")
	map("n", "<C-f>", "<CMD>Telescope current_buffer_fuzzy_find<CR>")

	--------------
	-- 快速编辑 --
	--------------
	-- plugin: vim-visual-multi
	map("n", "<", "<<")
	map("n", ">", ">>")
	map("i", "<C-S-J>", "<CMD>m .+1<CR><Cmd>normal ==<CR>")
	map("n", "<C-S-J>", "<CMD>m .+1<CR><Cmd>normal ==<CR>")
	map("i", "<C-S-K>", "<CMD>m .-2<CR><Cmd>normal ==<CR>")
	map("n", "<C-S-K>", "<CMD>m .-2<CR><Cmd>normal ==<CR>")
	map("i", "<C-j>", "<End><CR>")
	map("n", "<C-j>", "<CMD>put =repeat(nr2char(10), v:count1)<CR>")
	map("i", "<C-k>", "repeat('<Del>', strchars(getline('.')) - getcurpos()[2] + 1)", { expr = true })
	map("c", "<C-k>", "repeat('<Del>', strchars(getcmdline()) - getcmdpos() + 1)", { expr = true })
	map("i", "<C-l>", "<CMD>call C_Right()<CR><Right>")
	map("c", "<C-l>", "<C-Right>")
	map("i", "<C-z>", "<CMD>undo<CR>")
	map("i", "<C-S-z>", "<CMD>redo<CR>")

	--------------
	-- 普通模式 --
	--------------
	-- plugin: vim-expand-region
	-- plugin: vim-textobj-user
	-- plugin: vim-textobj-entire
	-- plugin: vim-textobj-indent
	-- plugin: vim-textobj-line
	-- plugin: vim-textobj-parameter
	-- plugin: nvim-treesitter-textobjects
	-- plugin: vim-repeate
	-- plugin: vim-surround
	map("n", "S", "i<CR><Esc>")

	--------------
	-- 复制粘贴 --
	--------------
	map("i", "<C-v>", "<C-r>+")
	map("n", "Y", "y$")
	map("v", "=p", '"0p')
	map("n", "=p", '"0p')
	map("n", "=P", '"0P')
	map("n", "=o", "<CMD>put =@0<CR>")
	map("n", "=O", "<CMD>put! =@0<CR>")
	map("v", "<Space>y", '"+y')
	map("v", "<Space>p", '"+p')
	lvim.builtin.which_key.mappings["<Space>"] = { "<CMD>let @+ = @0<CR>", "Copy Register 0 to Clipboard" }
	lvim.builtin.which_key.mappings["y"] = { '"+y', "Yank to Clipboard" }
	lvim.builtin.which_key.mappings["Y"] = { '"+y$', "Yank All Right to Clipboard" }
	lvim.builtin.which_key.mappings["p"] = { '"+p', "Paste Clipboard After Cursor" }
	lvim.builtin.which_key.mappings["P"] = { '"+P', "Paste Clipboard Before Cursor" }
	lvim.builtin.which_key.mappings["o"] = { "<CMD>put =@+<CR>", "Paste Clipboard to Next Line" }
	lvim.builtin.which_key.mappings["O"] = { "<CMD>put! =@+<CR>", "Paste Clipboard to Previous Line" }
	lvim.builtin.which_key.mappings["by"] = { "<CMD>%y +<CR>", "Yank Whole Buffer to Clipboard" }
	lvim.builtin.which_key.mappings["bp"] = { '<CMD>%d<CR>"+P', "Patse Clipboard to Whole Buffer" }

	--------------
	-- 语言服务 --
	--------------
	-- plugin: fidget.nvim
	-- plugin: lsp_signature.nvim
	-- plugin: telescope-luasnip.nvim
	-- plugin: clangd_extensions.nvim
	-- plugin: nvim-ts-qutotag
	lvim.builtin.cmp.confirm_opts.select = true
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local lccm = require("lvim.core.cmp").methods
	lvim.builtin.cmp.mapping["<C-j>"] = nil
	lvim.builtin.cmp.mapping["<C-k>"] = nil
	lvim.builtin.cmp.mapping["<C-f>"] = nil
	lvim.builtin.cmp.mapping["<C-d>"] = nil
	lvim.builtin.cmp.mapping["<C-d>"] = nil
	lvim.builtin.cmp.mapping["<C-e>"] = cmp.mapping.scroll_docs(2)
	lvim.builtin.cmp.mapping["<C-y>"] = cmp.mapping.scroll_docs(-2)
	lvim.builtin.cmp.mapping["<CR>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.confirm(lvim.builtin.cmp.confirm_opts)
		else
			fallback()
		end
	end)
	lvim.builtin.cmp.mapping["<M-I>"] = cmp.mapping(function()
		if cmp.visible() then
			cmp.abort()
		else
			cmp.complete()
		end
	end)
	lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			if luasnip.expandable() and cmp.get_active_entry() == nil then
				luasnip.expand()
			else
				cmp.confirm(lvim.builtin.cmp.confirm_opts)
			end
		elseif luasnip.expandable() then
			luasnip.expand()
		elseif lccm.jumpable() then
			luasnip.jump(1)
		elseif lccm.check_backspace() then
			fallback()
		elseif lccm.is_emmet_active() then
			return vim.fn["cmp#complete"]()
		else
			fallback()
		end
	end, { "i", "s" })

	map("n", "<M-F>", '<CMD>lua require("lvim.lsp.utils").format({timeout_ms= 2000})<CR>')
	map("i", "<M-F>", '<CMD>lua require("lvim.lsp.utils").format({timeout_ms= 2000})<CR>')
	map("n", "<F2>", "<CMD>lua vim.lsp.buf.rename()<CR>")
	map("n", "<M-.>", "<CMD>lua vim.lsp.buf.code_action()<CR>")
	map("n", "<C-.>", "<CMD>lua vim.lsp.buf.code_action()<CR>")
	map("n", "<C-_>", "gcc", { noremap = false })
	map("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)", { noremap = false })
	map("i", "<C-_>", "<CMD>normal gcc<CR>")
	map("n", "<C-S-O>", "<CMD>Telescope lsp_document_symbols<CR>")
	map("n", "<C-t>", "<CMD>Telescope lsp_workspace_symbols<CR>")
	map("n", "<M-LeftMouse>", "<LeftMouse><CMD>lua vim.lsp.buf.definition()<CR>")
	map("n", "[e", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]e", "<CMD>lua vim.diagnostic.goto_next()<CR>")

	--------------
	-- 文件操作 --
	--------------
	-- plugin: suda.vim
	-- plugin: persistence.nvim
	lvim.builtin.which_key.mappings["<Tab>"] = { ":try | b# | catch | endtry<CR>", "Switch Buffer" }
	lvim.keys.normal_mode["<C-k>"] = false
	map("n", "L", "<CMD>BufferLineCycleNext<CR>")
	map("n", "H", "<CMD>BufferLineCyclePrev<CR>")
	map("n", "<C-k><C-o>", "<CMD>Telescope projects<CR>")
	map("n", "<C-k>o", ":e <C-r>=fnamemodify(expand('%:p'), ':p:h')<CR>/")
	map("n", "<C-k>n", "<CMD>enew<CR>")
	map("n", "<C-k>r", "<CMD>Telescope oldfiles<CR>")
	map("n", "<C-p>", "<CMD>Telescope find_files<CR>")
	map("n", "<C-s>", "<CMD>w<CR>")
	map("n", "<M-s>", "<CMD>SudaWrite<CR>")
	map("n", "<C-S-S>", ":saveas <C-r>=fnamemodify('.',':p')<CR>")
	map("n", "<C-k>s", "<CMD>wa<CR>")
	map("n", "<C-k>x", "<CMD>BufferKill<CR>")
	map("n", "<C-k>u", ":try | %bd | catch | endtry<CR>")
	map("n", "<C-k>w", "<CMD>%bd<CR>")
	map("n", "<Tab>", "<CMD>wincmd w<CR>")
	map("n", "<S-Tab>", "<CMD>wincmd W<CR>")
	map("n", "<C-w>z", "<CMD>lua require('user.keybindings').zoom_current_window()<CR>")
	lvim.builtin.which_key.mappings["q"] = { "<CMD>call SmartClose()<CR>", "Quit Cleverly" }
	lvim.builtin.which_key.mappings["S"] = {
		name = "Session",
		l = { "<CMD>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
		c = { "<CMD>lua require('persistence').load()<cr>", "Restore last session for current dir" },
		q = { "<CMD>lua require('persistence').stop()<cr>", "Quit without saving session" },
	}

	--------------
	-- 界面元素 --
	--------------
	-- plugin: dressing.nvim
	-- plugin: nvim-scrollbar
	-- plugin: sidebar.nvim
	-- plugin: symbols-outline.nvim
	-- plugin: todo-comments.nvim
	-- plugin: undotree
	-- plugin: trouble.nvim
	-- plugin: nvim-bqf
	map("n", "<C-S-E>", "<CMD>NvimTreeFindFile<CR>")
	map("n", "<C-S-M>", "<CMD>Trouble workspace_diagnostics<CR>")
	map("n", "<C-S-U>", "<CMD>lua require('telescope').extensions.notify.notify()<CR>")
	lvim.builtin.which_key.mappings["a"] = {
		name = "Application",
		e = { "<CMD>NvimTreeFindFile<CR>", "Explorer" },
		o = { "<CMD>SymbolsOutline<CR>", "Outline" },
		t = { "<CMD>TodoTrouble<CR>", "TODO" },
		u = { "<CMD>UndotreeToggle<CR>", "UndoTree" },
		c = { "<CMD>Calc<CR>", "Calculator" },
	}

	--------------
	-- 其他按键 --
	--------------
	map("n", "<M-e>", "<CMD>call Open_file_in_explorer()<CR>")
	map("n", "<M-z>", "<CMD>let &wrap=!&wrap<CR>")
	map("n", "<M-t>", "<CMD>TranslateW<CR>")
	map("v", "<M-t>", ":TranslateW<CR>")
	map("n", "<M-T>", "<CMD>TranslateR<CR>")
	map("v", "<M-T>", ":TranslateR<CR>")
	map("n", "<C-S-P>", "<CMD>Telescope commands<CR>")
	map("n", "<C-k><C-s>", "<CMD>Telescope keymaps<CR>")
	lvim.builtin.which_key.mappings[";"] = nil
	lvim.builtin.which_key.mappings["/"] = nil
	lvim.builtin.which_key.mappings["w"] = nil
	lvim.builtin.which_key.mappings["h"] = nil
	lvim.builtin.which_key.mappings["f"] = nil
	lvim.builtin.which_key.mappings["c"] = nil
	lvim.builtin.which_key.mappings["e"] = nil

	vim.cmd([[
function! C_Right() abort
  let left_text = getline('.')[getcurpos()[2]-1:]
  if left_text =~ '^\W*\s+$'
    normal $ge
  elseif left_text =~ '^\W*$'
    normal $
  else
    normal e
  endif
endf
function! SmartClose() abort
  if &bt ==# 'nofile' || &bt ==# 'quickfix'
    quit
    return
  endif
  let num = winnr('$')
  for i in range(1, num)
    let buftype = getbufvar(winbufnr(i), '&buftype')
    if buftype ==# 'quickfix' || buftype ==# 'nofile'
      let num = num - 1
    elseif getwinvar(i, '&previewwindow') == 1 && winnr() !=# i
      let num = num - 1
    endif
  endfor
  if num == 1
    if len(getbufinfo({'buflisted':1,'bufloaded':1,'bufmodified':1})) > 0
      echohl WarningMsg
      echon 'There are some buffer modified! Quit/Save/Cancel'
      let rs = nr2char(getchar())
      echohl None
      if rs ==? 'q'
        qall!
      elseif rs ==? 's' || rs ==? 'w'
        redraw
        wall
        qall
      else
        redraw
        echohl ModeMsg
        echon 'canceled!'
        echohl None
      endif
    else
      qall
    endif
  else
    quit
  endif
endf

function! Open_file_in_explorer() abort
  if has('win32') || has('wsl')
    call jobstart('explorer.exe .')
  elseif has('unix')
    call jobstart('xdg-open .')
  endif
endf
]])
end

function M.zoom_current_window()
	local cur_win = vim.api.nvim_get_current_win()
	vim.api.nvim_set_var("non_float_total", 0)
	vim.cmd("windo if &buftype != 'nofile' | let g:non_float_total += 1 | endif")
	vim.api.nvim_set_current_win(cur_win or 0)
	if vim.api.nvim_get_var("non_float_total") == 1 then
		if vim.fn.tabpagenr("$") == 1 then
			return
		end
		vim.cmd("tabclose")
	else
		local last_cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd("tabedit %:p")
		vim.api.nvim_win_set_cursor(0, last_cursor)
	end
end

return M
