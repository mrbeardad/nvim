let $XDG_DATA_HOME = $APPDATA
let $XDG_CONFIG_HOME = $LOCALAPPDATA
let $XDG_CACHE_HOME = $TEMP
let $LUNARVIM_RUNTIME_DIR = $XDG_DATA_HOME.'\lunarvim'
let $LUNARVIM_CONFIG_DIR = $XDG_CONFIG_HOME.'\lvim'
let $LUNARVIM_CACHE_DIR = $XDG_CACHE_HOME.'\lvim'
let $LUNARVIM_BASE_DIR = $LUNARVIM_RUNTIME_DIR.'\lvim'

if !exists('g:vscode')
  exe 'luafile '.$LUNARVIM_BASE_DIR.'\init.lua'
else
  set shadafile=NONE
  set noswapfile
  set nobackup
  set undofile
  set ignorecase
  set smartcase

  " disable builtin plugins
  let disabled_plugins = [
    \ "2html_plugin",
    \ "getscript",
    \ "getscriptPlugin",
    \ "gzip",
    \ "logipat",
    \ "netrw",
    \ "netrwPlugin",
    \ "netrwSettings",
    \ "netrwFileHandlers",
    \ "matchit",
    \ "tar",
    \ "tarPlugin",
    \ "rrhelper",
    \ "spellfile_plugin",
    \ "vimball",
    \ "vimballPlugin",
    \ "zip",
    \ "zipPlugin",
    \ ]
  for plugin in disabled_plugins 
    exe 'let g:loaded_'.plugin.' = 1'
  endfor

  " init custom plugins
  let g:matchup_matchparen_enabled = 0
  let g:matchup_surround_enabled = 1
  let g:asterisk#keeppos = 1

  " load custom plugins
  let enabled_plugins = [
    \ 'hop.nvim',
    \ 'vim-matchup',
    \ 'vim-asterisk',
    \ 'vim-cool',
    \ 'vim-expand-region',
    \ 'vim-repeat',
    \ 'vim-textobj-user',
    \ 'vim-textobj-entire',
    \ 'vim-textobj-indent',
    \ 'vim-textobj-line',
    \ 'vim-textobj-parameter',
    \ 'vim-surround',
  \ ]
  for plugin in enabled_plugins
    exe 'set rtp+='.$LUNARVIM_RUNTIME_DIR.'\site\pack\lazy\opt\'.plugin
  endfor

  " config custom plugins and set keymaps
  lua << EOF
    require('hop').setup()
    vim.keymap.set('', 'f', function()
      require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        current_line_only = true
      })
    end)
    vim.keymap.set('', 'F', function()
      require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        current_line_only = true
      })
    end)
    vim.keymap.set('', 't', function()
      require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1
      })
    end)
    vim.keymap.set('', 'T', function()
      require("hop").hint_char1({
        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = 1
      })
    end)
    vim.keymap.set('', ';', function()
      require("hop").hint_char2()
    end)
    vim.keymap.set('', ',', function()
      require("hop").hint_lines({ multi_windows = true })
    end)

    vim.keymap.set('n', '<Insert>', function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      vim.g.fuck = col
      if col + 1 ~= vim.b.pos_col_before_cw then
        return 'a'
      else
        return 'i'
      end
    end, { expr = true })
EOF

  nnoremap mm <cmd>call VSCodeNotify('bookmarks.toggle')<CR>
  nnoremap mi <cmd>call VSCodeNotify('bookmarks.toggleLabeled')<CR>
  nnoremap mn <cmd>call VSCodeNotify('bookmarks.jumpToNext')<CR>
  nnoremap mp <cmd>call VSCodeNotify('bookmarks.jumpToPrevious')<CR>
  nnoremap ml <cmd>call VSCodeNotify('bookmarks.list')<CR>
  nnoremap mL <cmd>call VSCodeNotify('bookmarks.listFromAllFiles')<CR>
  nnoremap mc <cmd>call VSCodeNotify('bookmarks.clear')<CR>
  nnoremap mC <cmd>call VSCodeNotify('bookmarks.clearFromAllFiles')<CR>
  nnoremap [c <cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR><Cmd>call VSCodeNotify('workbench.action.compareEditor.previousChange')<CR>
  nnoremap ]c <cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR><Cmd>call VSCodeNotify('workbench.action.compareEditor.nextChange')<CR>
  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  map gz# <Plug>(asterisk-gz#)
  nnoremap <expr> n 'Nn'[v:searchforward]
  nnoremap <expr> N 'nN'[v:searchforward]
  nnoremap <silent><C-L> :nohl<CR>
  vmap v <Plug>(expand_region_expand)
  vmap V <Plug>(expand_region_shrink)
  vnoremap <C-H> <cmd>call VSCodeNotifyVisual('editor.action.startFindReplaceAction', 1)<CR><Esc>
  nnoremap < <<
  nnoremap > >>
  inoremap <C-Z> <cmd>undo<CR>
  inoremap <C-S-Z> <cmd>redo<CR>
  vnoremap <C-N> <cmd>call VSCodeNotifyVisual('editor.action.addSelectionToNextFindMatch', 1)<CR><Esc>
  vnoremap <C-S-N> <cmd>call VSCodeNotifyVisual('editor.action.addSelectionToPreviousFindMatch', 1)<CR><Esc>
  vnoremap <C-S-L> <cmd>call VSCodeNotifyVisual('editor.action.selectHighlights', 1)<CR>
  vmap I mi
  vmap A ma
  vnoremap c "_c
  nnoremap c "_c
  nmap cw <cmd>let b:pos_col_before_cw=getpos('.')[2]<CR>"_dw<Insert>
  nmap cW <cmd>let b:pos_col_before_cw=getpos('.')[2]<CR>"_dW<Insert>
  nnoremap s "_s
  nnoremap S i<CR><Esc>
  nnoremap Y y$
  nnoremap zp "0p
  vnoremap zp "0p
  nnoremap zP "0P
  nnoremap zo <cmd>put =@0<CR>
  nnoremap zO <cmd>put! =@0<CR>
  nnoremap zg <cmd>let @+ = @0<CR>
  nnoremap gy "+y
  vnoremap gy "+y
  nnoremap gY "+y$
  nnoremap gp "+p
  vnoremap gp "+p
  nnoremap gP "+P
  nnoremap go <cmd>put =@+<CR>
  nnoremap gO <cmd>put! =@+<CR>
  nnoremap <Space>by <cmd>%y +<CR>
  nnoremap <Space>bp <cmd>%d<CR>"+P
  nnoremap gr <cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  nnoremap gI <cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
  nnoremap [d <cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
  nnoremap ]d <cmd>call VSCodeNotify('editor.action.marker.next')<CR>
  nnoremap H <cmd>call VSCodeNotify('workbench.action.previousEditorInGroup')<CR> 
  nnoremap L <cmd>call VSCodeNotify('workbench.action.nextEditorInGroup')<CR> 
  nnoremap za <cmd>call VSCodeNotify('editor.fold')<CR>
endif
