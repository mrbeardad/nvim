-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--------------------------------------------------------------------------------
-- vim options
--------------------------------------------------------------------------------
vim.opt.backup = true
vim.opt.backupdir = join_paths(get_cache_dir(), 'backup')
vim.opt.swapfile = true
vim.opt.directory = join_paths(get_cache_dir(), 'swap')
vim.opt.clipboard = ''
vim.opt.colorcolumn = '100'
vim.opt.confirm = true
vim.opt.guicursor = 'n:block-blinkon10,i-ci:ver15-blinkon10,c:hor15-blinkon10,v-sm:block,ve:ver15,r-cr-o:hor10'
vim.opt.pumblend = 15
vim.opt.winblend = 15
vim.opt.showcmd = true
vim.opt.shortmess:append('S')
vim.opt.list = true
vim.opt.listchars = 'tab:→ ,eol:↵,trail:·,extends:↷,precedes:↶'
vim.opt.relativenumber = true
vim.opt.timeoutlen = 500
vim.opt.wildignorecase = true
-- Cursorline highlighting control, only have it on in the active buffer
vim.opt.cursorline = true
local autogroup_cursorline = vim.api.nvim_create_augroup('CursorLineControl', { clear = true })
vim.api.nvim_create_autocmd('WinLeave', {
  group = autogroup_cursorline,
  callback = function()
    vim.opt_local.cursorline = false
    if vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'help' then
      vim.opt_local.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd('WinEnter', {
  group = autogroup_cursorline,
  callback = function()
    if vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'help' then
      vim.opt_local.cursorline = true
      vim.opt_local.relativenumber = true
    end
  end,
})
-- Enable powershell as your default shell
vim.opt.shell = "pwsh.exe -NoLogo"
vim.opt.shellcmdflag =
"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.cmd [[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		set shellquote= shellxquote=
  ]]

--------------------------------------------------------------------------------
-- lvim options
----------v----------------------------------------------------------------------
lvim.colorscheme = 'tokyonight'
require('tokyonight').setup({
  style = 'moon',
  dim_inactive = true,
  lualine_bold = true,
})
local colors_palette = require('tokyonight.colors').setup()
lvim.format_on_save.enabled = true
require('lvim.lsp.null-ls.linters').setup({
  { name = 'golangci_lint' },
  { name = 'eslint_d' },
  { name = 'ruff' },
  { name = 'shellcheck' },
  { name = 'sqlfluff',     args = { '--dialect', 'mysql' } },
  { name = 'markdownlint' },
  { name = 'tidy' },
  { name = 'stylelint' },
})
require('lvim.lsp.null-ls.formatters').setup({
  { name = 'eslint_d' },
  { name = 'black' },
  {
    name = 'prettier',
    filetypes = { 'css', 'scss', 'less', 'html', 'json', 'jsonc', 'yaml', 'markdown',
      'markdown.mdx', 'graphql', 'handlebars' }
  },
  { name = 'shfmt' },
  { name = 'sqlfluff' },
})
lvim.builtin.cmp.confirm_opts.select = true
lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.lualine.sections.lualine_y = { { 'fileformat' }, { 'encoding' } }
lvim.builtin.lualine.sections.lualine_z = { { ' %c  %l/%L', type = 'stl' } }
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.nvimtree.setup.on_attach = function(bufnr)
  local api = require "nvim-tree.api"

  local function telescope_find_files(_)
    require("lvim.core.nvimtree").start_telescope "find_files"
  end

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.del('n', '<Tab>', { buffer = bufnr })

  local useful_keys = {
    ["l"] = { api.node.open.edit, opts "Open" },
    ["o"] = { api.node.open.edit, opts "Open" },
    ["<CR>"] = { api.node.open.edit, opts "Open" },
    ["v"] = { api.node.open.vertical, opts "Open: Vertical Split" },
    ["h"] = { api.node.navigate.parent_close, opts "Close Directory" },
    ["C"] = { api.tree.change_root_to_node, opts "CD" },
    ["<C-F>"] = { telescope_find_files, opts "Telescope Find File" },
  }

  require("lvim.keymappings").load_mode("n", useful_keys)
end
lvim.builtin.telescope.defaults.layout_config.center = { width = 0.75 }
lvim.builtin.telescope.defaults.mappings = {
  i = { ['<Esc>'] = require('telescope.actions').close, },
}
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.gitsigns.opts.on_attach = function(bufnr)
  local gs = package.loaded.gitsigns
  require('which-key').register({
    [']c'] = {
      function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end,
      'Next diff change or git hunk'
    },
    ['[c'] = {
      function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end,
      'Previous diff change or git hunk'
    }
  }, { expr = true, buffer = bufnr })
end
lvim.builtin.which_key.setup.plugins.marks = true
lvim.builtin.which_key.setup.plugins.registers = true
lvim.builtin.which_key.setup.plugins.presets = {
  operators = false,
  motions = false,
  text_objects = false,
  windows = true,
  nav = true,
  z = true,
  g = true,
}
-- NOTE: in order to run which-key setup before which-key register, register mappings after plugin manager setup
local autogroup_whichkey = vim.api.nvim_create_augroup('WhichKeyMapping', { clear = true })
local function which_key_register(mapping, opt)
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = autogroup_whichkey,
    callback = function()
      require('which-key').register(mapping, opt)
    end,
  })
end

--------------------------------------------------------------------------------
-- custom plugins
--------------------------------------------------------------------------------
local disabled_plugins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'matchit',
  'tar',
  'tarPlugin',
  'rrhelper',
  'spellfile_plugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
}
for _, plugin in pairs(disabled_plugins) do
  vim.g['loaded_' .. plugin] = 1
end

lvim.plugins = {
  {
    'karb94/neoscroll.nvim',
    event = 'WinScrolled',
    config = function()
      require('neoscroll').setup({
        easing_function = 'sine'
      })
      require('which-key').register({ ['z<CR>'] = { 'zt', 'Top this line' } }, { noremap = false })
    end,
  },
  {
    'phaazon/hop.nvim',
    keys = {
      { 'f', mode = { 'n', 'v', 'o' } },
      { 'F', mode = { 'n', 'v', 'o' } },
      { 't', mode = { 'n', 'v', 'o' } },
      { 'T', mode = { 'n', 'v', 'o' } },
      { ';', mode = { 'n', 'v', 'o' } },
      { ',', mode = { 'n', 'v', 'o' } },
    },
    config = function()
      require('hop').setup()
      vim.keymap.set('', 'f', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.AFTER_CURSOR,
          current_line_only = true
        })
      end)
      vim.keymap.set('', 'F', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
          current_line_only = true
        })
      end)
      vim.keymap.set('', 't', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1
        })
      end)
      vim.keymap.set('', 'T', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1
        })
      end)
      vim.keymap.set('', ';', function()
        require('hop').hint_char2()
      end)
      vim.keymap.set('', ',', function()
        require('hop').hint_lines({ multi_windows = true })
      end)
    end,
  },
  {
    'andymass/vim-matchup',
    event = 'BufRead',
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
    config = function()
      vim.cmd('highlight MatchParen gui=italic,bold guifg=' .. colors_palette.orange
        .. ' guibg=' .. colors_palette.fg_gutter)
    end
  },
  {
    'ethanholz/nvim-lastplace',
    event = 'BufRead',
    config = function()
      require('nvim-lastplace').setup({})
    end,
  },
  {
    'MattesGroeger/vim-bookmarks',
    event = 'BufRead',
    init = function()
      vim.g.bookmark_sign = ''
      vim.g.bookmark_annotation_sign = ''
      vim.g.bookmark_display_annotation = 1
      vim.g.bookmark_no_default_key_mappings = 1
      vim.g.bookmark_auto_save_file = join_paths(get_cache_dir(), 'vim-bookmarks')
    end,
    config = function()
      vim.cmd('highlight BookmarkAnnotationSignDefault guifg=' .. colors_palette.yellow)
      vim.cmd('highlight BookmarkSignDefault guifg=' .. colors_palette.yellow)
      require('which-key').register({
        m = { '<Plug>BookmarkToggle', 'Toggle bookmark', },
        i = { '<Plug>BookmarkAnnotate', 'Annotate bookmark', },
        n = { "m'<Plug>BookmarkNext", 'Next bookmark', },
        p = { "m'<Plug>BookmarkPrev", 'Previous bookmark', },
        c = { '<Plug>BookmarkClear', 'Clear bookmarks in current file', },
        C = { '<Plug>BookmarkClearAll', 'Clear all bookmarks', },
        j = { '<Plug>BookmarkMoveDown', 'Move bookmark down', },
        k = { '<Plug>BookmarkMoveUp', 'Move bookmark up', },
        g = { '<Plug>BookmarkMoveToLine', 'Move bookmark to specified line', },
      }, { prefix = 'm', noremap = false })
    end,
  },
  {
    'tom-anders/telescope-vim-bookmarks.nvim',
    lazy = true,
    init = function()
      require('which-key').register({
        l = { '<cmd>lua require("telescope").extensions.vim_bookmarks.current_file()<CR>',
          'List bookmarks in current file', },
        L = { '<cmd>lua require("telescope").extensions.vim_bookmarks.all()<CR>', 'List all bookmarks', },
      }, { prefix = 'm' })
    end,
    config = function()
      require('telescope').load_extension('vim_bookmarks')
    end,
  },
  {
    'haya14busa/vim-asterisk',
    keys = {
      { '*',   mode = { 'n', 'v', 'o' } },
      { '#',   mode = { 'n', 'v', 'o' } },
      { 'g*',  mode = { 'n', 'v', 'o' } },
      { 'g#',  mode = { 'n', 'v', 'o' } },
      { 'z*',  mode = { 'n', 'v', 'o' } },
      { 'z#',  mode = { 'n', 'v', 'o' } },
      { 'gz*', mode = { 'n', 'v', 'o' } },
      { 'gz#', mode = { 'n', 'v', 'o' } },
    },
    init = function()
      vim.cmd('let g:asterisk#keeppos = 1')
    end,
    config = function()
      require('which-key').register({
        ['*'] = { '<Plug>(asterisk-*)', 'Next word' },
        ['#'] = { '<Plug>(asterisk-#)', 'Next word' },
        ['g*'] = { '<Plug>(asterisk-g*)', 'Next word' },
        ['g#'] = { '<Plug>(asterisk-g#)', 'Next word' },
        ['z*'] = { '<Plug>(asterisk-z*)', 'Next word' },
        ['z#'] = { '<Plug>(asterisk-z#)', 'Next word' },
        ['gz*'] = { '<Plug>(asterisk-gz*)', 'Next word' },
        ['gz#'] = { '<Plug>(asterisk-gz#)', 'Next word' },
      }, { mode = { 'n', 'v', 'o' }, noremap = false })
    end
  },
  {
    'kevinhwang91/nvim-hlslens',
    event = 'VimEnter',
    config = function()
      require('hlslens').setup({
        override_lens = function(render, posList, nearest, idx, relIdx)
          local sfw = vim.v.searchforward == 1
          local indicator, text, chunks
          local absRelIdx = math.abs(relIdx)
          if absRelIdx > 1 then
            indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
          elseif absRelIdx == 1 then
            indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
          else
            indicator = ''
          end
          local lnum, col = unpack(posList[idx])
          if nearest then
            local cnt = #posList
            if indicator ~= '' then
              text = ('[%s %d/%d]'):format(indicator, idx, cnt)
            else
              text = ('[%d/%d]'):format(idx, cnt)
            end
            chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
          else
            text = ('[%s %d]'):format(indicator, idx)
            chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
      })
      vim.keymap.set('', 'n', function()
        require('hlslens').start()
        if vim.v.searchforward == 1 then
          return 'n'
        else
          return 'N'
        end
      end, { expr = true })
      vim.keymap.set('', 'N', function()
        require('hlslens').start()
        if vim.v.searchforward == 1 then
          return 'N'
        else
          return 'n'
        end
      end, { expr = true })
    end
  },
  {
    'romainl/vim-cool',
    event = 'CursorMoved',
  },
  {
    'mg979/vim-visual-multi',
    keys = { { 'I', mode = 'v' }, { 'A', mode = 'v' }, { '<C-N>', mode = { 'n', 'v' } },
      { '<C-S-L>', mode = { 'n', 'v' } } },
    dependencies = { 'nvim-autopairs' }, -- autopairs lazy loading when InsertEnter could override VM backspace
    init = function()
      vim.g.VM_leader = '<Space>m'
      -- to adapt lazy load
      lvim.builtin.which_key.mappings['m'] = { function()
        vim.cmd('Lazy load vim-visual-multi')
        require('which-key').register({ m = { name = 'Multi Cursor' } }, { prefix = '<space>' })
        require('which-key').show(' m', { mode = 'n', auto = true })
      end, 'MultiCursor' }
      lvim.builtin.which_key.vmappings['m'] = { function()
        vim.cmd('Lazy load vim-visual-multi')
        require('which-key').register({ m = { name = 'Multi Cursor' } }, { prefix = '<space>' })
        require('which-key').show(' m', { mode = 'n', auto = true })
      end, 'MultiCursor' }
      vim.cmd([[
        function! VM_Start()
          " VM will override <BS>
          iunmap <BS>
          " lualine will override VM statusline
          lua require('lualine').hide()
          " prevent hlslens display in vm
          set eventignore=CursorMoved
          " solve the trouble when vmap A and I
          set hls
        endf
        function! VM_Exit()
          inoremap <expr><BS> v:lua.MPairs.autopairs_bs()
          lua require('lualine').hide({unhide=true})
          set eventignore=
          vim.g.VM_quit_after_leaving_insert_mode = 0
        endf
       ]])
    end,
    config = function()
      vim.keymap.set('n', '<C-S-L>', '<Plug>(VM-Select-All)', { remap = true })
      vim.keymap.set('v', '<C-S-L>', '<Plug>(VM-Visual-All)', { remap = true })
      vim.keymap.set('v', 'I', function()
        vim.g.VM_quit_after_leaving_insert_mode = 1
        return '<Space>mai'
      end, { expr = true, remap = true })
      vim.keymap.set('v', 'A', function()
        vim.g.VM_quit_after_leaving_insert_mode = 1
        return '<Space>maa'
      end, { expr = true, remap = true })
    end,
  },
  {
    'terryma/vim-expand-region',
    keys = { { 'v', mode = 'v' }, { 'V', mode = 'v' } },
    config = function()
      vim.keymap.set('v', 'v', '<Plug>(expand_region_expand)', { remap = true })
      vim.keymap.set('v', 'V', '<Plug>(expand_region_shrink)', { remap = true })
    end,
  },
  {
    'tpope/vim-repeat',
  },
  {
    'kana/vim-textobj-user',
  },
  {
    'kana/vim-textobj-entire',
    keys = { 'c', 'd', 'y' },
  },
  {
    'kana/vim-textobj-indent',
    keys = { 'c', 'd', 'y' },
  },
  {
    'kana/vim-textobj-line',
    keys = { 'c', 'd', 'y' },
  },
  {
    'sgur/vim-textobj-parameter',
    keys = { 'c', 'd', 'y' },
  },
  {
    'tpope/vim-surround',
    keys = { 'c', 'd', 'y' },
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'BufRead',
    config = function()
      require('lsp_signature').setup({
        hint_prefix = ' ',
      })
    end,
  },
  {
    'benfowler/telescope-luasnip.nvim',
    lazy = true,
    init = function()
      vim.keymap.set({ 'n', 'i' }, '<M-i>', '<cmd>lua require"telescope".extensions.luasnip.luasnip{}<CR>')
    end,
    config = function()
      require('telescope').load_extension('luasnip')
    end
  },
  {
    'p00f/nvim-ts-rainbow',
    event = 'BufRead'
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    event = 'BufRead',
    config = function()
      require('scrollbar').setup({
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        },
      })
    end,
  },
  {
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
    init = function()
      lvim.builtin.which_key.mappings['o'] = { '<cmd>SymbolsOutline<CR>', 'SymbolsOutline' }
    end,
    config = function()
      require('symbols-outline').setup({
        width = 20,
        autofold_depth = 1,
      })
    end
  },
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle' },
    init = function()
      lvim.builtin.which_key.mappings['t'] = {
        name = 'Trouble',
        d = { '<cmd>TroubleToggle workspace_diagnostics<CR>', 'Diagnostics' },
        t = { '<cmd>TodoTrouble<CR>', 'TODOs' }
      }
      lvim.lsp.buffer_mappings.normal_mode['gd'] = { "m'<cmd>Trouble lsp_definitions<CR>", 'Goto definitions' }
      lvim.lsp.buffer_mappings.normal_mode['gr'] = { "m'<cmd>Trouble lsp_references<CR>", 'Goto references' }
      lvim.lsp.buffer_mappings.normal_mode['gI'] = { "m'<cmd>Trouble lsp_implementations<CR>", 'Goto implementations' }
    end,
    config = function()
      require('trouble').setup()
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufRead',
    config = function()
      require('todo-comments').setup()
    end,
  },
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle' },
    init = function()
      lvim.builtin.which_key.mappings['u'] = { '<cmd>UndotreeToggle<CR>', 'UndoTree' }
    end
  },
  {
    'stevearc/dressing.nvim',
    event = 'VimEnter',
    config = function()
      require('dressing').setup()
    end,
  },
  {
    'rcarriga/nvim-notify',
    event = 'VimEnter',
    config = function()
      local notify = require('notify')
      notify.setup({
        stages = 'slide',
      })
      vim.notify = notify
    end
  },
  {
    'voldikss/vim-translator',
    keys = { { '<M-t>', mode = { 'n', 'v' } } },
    init = function()
      vim.g.translator_default_engines = { 'bing', 'haici' }
    end,
    config = function()
      vim.keymap.set('n', '<M-t>', '<Plug>TranslateW')
      vim.keymap.set('v', '<M-t>', '<Plug>TranslateWV')
    end
  }
}

--------------------------------------------------------------------------------
-- key bindings
--------------------------------------------------------------------------------
vim.keymap.set('c', '<C-A>', '<C-B>')

-- HACK: terminal map ctrl+i to alt+shift+i
vim.keymap.set('n', '<M-I>', '<C-I>')

vim.keymap.set('n', '<C-L>', '<cmd>nohl<CR><C-L>')
vim.keymap.set('c', '<M-w>', '\\<\\><Left><Left>')
vim.keymap.set('c', '<M-r>', '\\v')
vim.keymap.set('c', '<M-c>', '\\C')
vim.keymap.set('n', '<C-S-F>', '<cmd>Telescope live_grep<CR>')

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<', '<<')
vim.keymap.set('n', '>', '>>')
vim.keymap.set('i', '<C-S-J>', '<cmd>m .+1<CR><Cmd>normal ==<CR>')
vim.keymap.set('n', '<C-S-J>', '<cmd>m .+1<CR><Cmd>normal ==<CR>')
vim.keymap.set('i', '<C-S-K>', '<cmd>m .-2<CR><Cmd>normal ==<CR>')
vim.keymap.set('n', '<C-S-K>', '<cmd>m .-2<CR><Cmd>normal ==<CR>')
vim.keymap.set('i', '<C-J>', '<End><CR>')
vim.keymap.set('n', '<C-J>', '<cmd>put =repeat(nr2char(10), v:count1)<CR>')
vim.keymap.set('i', '<C-K>', function()
  local len = string.len(vim.api.nvim_get_current_line())
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return string.rep('<Del>', (len - col))
end, { expr = true })
vim.keymap.set('c', '<C-K>', function()
  local len = string.len(vim.fn.getcmdline())
  local col = vim.fn.getcmdpos()
  return string.rep('<Del>', (len - col + 1))
end, { expr = true })
vim.keymap.set('i', '<C-L>', '<Esc>ea')
vim.keymap.set('c', '<C-L>', '<C-Right>')
vim.keymap.set('i', '<C-Z>', '<cmd>undo<CR>')
vim.keymap.set('i', '<C-S-Z>', '<cmd>redo<CR>')

vim.keymap.set('v', 'c', '"_c')
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', '<Insert>', function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col + 1 ~= vim.b.pos_col_before_cw then
    return 'a'
  else
    return 'i'
  end
end, { expr = true })
vim.keymap.set('n', 'cw', '<cmd>let b:pos_col_before_cw=getpos(".")[2]<CR>"_dw<Insert>', { remap = true })
vim.keymap.set('n', 'cW', '<cmd>let b:pos_col_before_cw=getpos(".")[2]<CR>"_dW<Insert>', { remap = true })
vim.keymap.set('n', 's', '"_s')
vim.keymap.set('n', 'S', 'i<CR><Esc>')

vim.keymap.set('i', '<C-V>', '<C-R>+')
vim.keymap.set('c', '<C-V>', '<C-R>+')
vim.keymap.set('n', 'Y', '"0y$')
which_key_register({
  p = { '"0p', 'Paste last yank after cursor' },
  P = { '"0P', 'Paste last yank before cursor' },
  o = { '<cmd>put =@0<CR>', 'Paste last yank after current line' },
  O = { '<cmd>put! =@0<CR>', 'Paste last yank before current line' },
  g = { '<cmd>let @+ = @0<CR>', 'Copy last yank to clip' }
}, { prefix = 'z' })
which_key_register({
  p = { '"0p', 'Paste last yank after cursor' },
}, { prefix = 'z', mode = 'v' })
which_key_register({
  y = { '"+y', 'Yank to clip' },
  Y = { '"+y$', 'Yank EOL to clip' },
  p = { '"+p', 'Paste from clip after cursor' },
  P = { '"+P', 'Paste from clip before cursor' },
  o = { '<cmd>put =@+<CR>', 'Paste from clip after current line' },
  O = { '<cmd>put! =@+<CR>', 'Paste from clip before current line' }
}, { prefix = 'g' })
which_key_register({
  y = { '"+y', 'Yank to clip' },
  p = { '"+p', 'Paste from clip after cursor' },
}, { prefix = 'g', mode = 'v' })
lvim.builtin.which_key.mappings['by'] = { '<cmd>%y +<CR>', 'Yank whole buffer to clipboard' }
lvim.builtin.which_key.mappings['bp'] = { '<cmd>%d<CR>"+P', 'Patse clipboard to whole buffer' }

local cmp = require('cmp')
local luasnip = require('luasnip')
local lccm = require('lvim.core.cmp').methods
lvim.builtin.cmp.mapping['<C-J>'] = nil
lvim.builtin.cmp.mapping['<C-K>'] = nil
lvim.builtin.cmp.mapping['<C-D>'] = nil
lvim.builtin.cmp.mapping['<C-F>'] = nil
lvim.builtin.cmp.mapping['<C-E>'] = cmp.mapping.scroll_docs(4)
lvim.builtin.cmp.mapping['<C-Y>'] = cmp.mapping.scroll_docs(-4)
lvim.builtin.cmp.mapping['<M-I>'] = cmp.mapping(function()
  if cmp.visible() then
    cmp.abort()
  else
    cmp.complete()
  end
end)
lvim.builtin.cmp.mapping['<Tab>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    local confirm_opts = vim.deepcopy(lvim.builtin.cmp.confirm_opts) -- avoid mutating the original opts below
    local is_insert_mode = function()
      return vim.api.nvim_get_mode().mode:sub(1, 1) == 'i'
    end
    if is_insert_mode() then -- prevent overwriting brackets
      confirm_opts.behavior = require('cmp.types.cmp').ConfirmBehavior.Insert
    end
    if cmp.confirm(confirm_opts) then
      return -- success, exit early
    end
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  elseif lccm.jumpable(1) then
    luasnip.jump(1)
  elseif lccm.has_words_before() then
    -- cmp.complete()
    fallback()
  else
    fallback()
  end
end, { 'i', 's' })
vim.keymap.set({ 'n', 'i' }, '<M-F>', '<cmd>lua require("lvim.lsp.utils").format({timeout=750})<CR>')
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', '<M-.>', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<C-.>', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true })
vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)', { remap = true })
vim.keymap.set('i', '<C-_>', '<cmd>normal gcc<CR>')
vim.keymap.set('n', '<C-S-O>', '<cmd>Telescope lsp_document_symbols<CR>')
vim.keymap.set('n', '<C-T>', '<cmd>Telescope lsp_workspace_symbols<CR>')
which_key_register({ ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Previous diagnostic' }, },
  { noremap = false })
which_key_register({ [']d'] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Next diagnostic' }, }, { noremap = false })

lvim.keys.normal_mode['<C-K>'] = false
lvim.builtin.which_key.mappings['/'] = nil
lvim.builtin.which_key.mappings['c'] = nil
lvim.builtin.which_key.mappings['f'] = nil
lvim.builtin.which_key.mappings['h'] = nil
lvim.builtin.which_key.mappings['w'] = nil
lvim.builtin.which_key.mappings['<Tab>'] = { ':try | b# | catch | endtry<CR>', 'Switch buffer' }
lvim.builtin.which_key.mappings['bs'] = { '<cmd>Telescope buffers<CR>', 'Search' }
lvim.builtin.which_key.mappings['bP'] = { '<cmd>BufferLineTogglePin<CR>', 'Pin' }
lvim.builtin.which_key.mappings['bw'] = { '<cmd>noautocmd w<CR>', 'Save without format' }
lvim.builtin.which_key.mappings['bd'] = { '<cmd>BufferKill<CR>', 'Delete' }
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', '<C-P>', '<cmd>Telescope find_files hidden=true<CR>')
vim.keymap.set('n', '<C-S>', '<cmd>w<CR>')
vim.keymap.set('n', '<C-S-S>', ':saveas <C-R>=fnamemodify(".",":p")<CR>')
which_key_register({
  ['<C-O>'] = { '<cmd>Telescope projects<CR>', 'Open project' },
  o = { ':e <C-R>=fnamemodify(expand("%:p"), ":p:h")<CR>/', 'Open file' },
  n = { '<cmd>enew<CR>', 'New file' },
  r = { '<cmd>Telescope oldfiles<CR>', 'Open recent file' },
  s = { '<cmd>wa<CR>', 'Save all files' },
  u = { '<cmd>set noconfirm<CR>:try | %bd | catch | endtry<CR><cmd>set confirm<CR>', 'Close all saved files' },
  w = { '<cmd>%bd<CR>', 'Close all files' },
  ['<C-S>'] = { '<cmd>Telescope keymaps<CR>', 'Search keymaps' },
}, { prefix = '<C-K>' })
vim.keymap.set('n', '<Tab>', '<cmd>wincmd w<CR>')
vim.keymap.set('n', '<S-Tab>', '<cmd>wincmd W<CR>')
vim.keymap.set('n', '<C-W>z', '<cmd>ZoomWindow<CR>')
which_key_register({
  z = { '<cmd>ZoomWindow<CR>', 'Zoom window' }
}, { prefix = '<C-W>' })
lvim.builtin.which_key.mappings['q'] = { '<cmd>call SmartClose()<CR>', 'Quit' }
lvim.builtin.which_key.mappings['Q'] = { '<cmd>qa<CR>', 'Quit All' }

vim.keymap.set('n', '<C-S-E>', '<cmd>NvimTreeFindFile<CR>')
vim.keymap.set('n', '<C-S-M>', '<cmd>Trouble workspace_diagnostics<CR>')
vim.keymap.set('n', '<C-S-U>', '<cmd>lua require("telescope").extensions.notify.notify()<CR>')

vim.keymap.set('n', '<M-e>', '<cmd>call Open_file_in_explorer()<CR>')
vim.keymap.set('n', '<M-z>', '<cmd>let &wrap=!&wrap<CR>')
vim.keymap.set('n', '<C-S-P>', '<cmd>Telescope commands<CR>')

lvim.builtin.which_key.mappings['sT'] = { '<cmd>TodoTelescope<CR>', 'TODOs' }
lvim.builtin.which_key.mappings['sn'] = { '<cmd>lua require("telescope").extensions.notify.notify()<CR>', 'Notify' }
lvim.builtin.which_key.mappings['ph'] = { '<cmd>Lazy home<CR>', 'Home' }

vim.api.nvim_create_user_command('ZoomWindow', function()
  local cur_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_var('non_float_total', 0)
  vim.cmd('windo if &buftype != "nofile" | let g:non_float_total += 1 | endif')
  vim.api.nvim_set_current_win(cur_win or 0)
  if vim.api.nvim_get_var('non_float_total') == 1 then
    if vim.fn.tabpagenr('$') == 1 then
      return
    end
    vim.cmd('tabclose')
  else
    local last_cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd('tabedit %:p')
    vim.api.nvim_win_set_cursor(0, last_cursor)
  end
end, {})

vim.cmd([[
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
    call jobstart('explorer.exe '.expand('%:p:h'))
  elseif has('unix')
    call jobstart('xdg-open .')
  endif
endf
]])
