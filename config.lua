----------------------------------------
-- GENERAL
----------------------------------------
vim.opt.backup = true
vim.opt.backupdir = join_paths(get_cache_dir(), "backup")
vim.opt.swapfile = true
vim.opt.directory = join_paths(get_cache_dir(), "swap")
vim.opt.list = true
vim.opt.listchars = 'tab:→ ,eol:↵,trail:·,extends:↷,precedes:↶'
vim.opt.wildignorecase = true
vim.opt.colorcolumn = '100'
lvim.colorscheme = "onedarker"
lvim.log.level = "warn"
lvim.format_on_save = true

----------------------------------------
-- GUI
----------------------------------------
vim.opt.guicursor = 'n:block-blinkon10,i-ci:ver15-blinkon10,c:hor15-blinkon10,v-sm:block,ve:ver15,r-cr-o:hor10'
vim.opt.guifont = "NerdCodePro Font:h13"
vim.g.neovide_cursor_vfx_mode = "ripple"
-- vim.g.neovide_cursor_animation_length = 0.01

----------------------------------------
-- KEYMAPPINGS
----------------------------------------
vim.opt.timeoutlen = 350
lvim.leader = "space"

----------------------------------------
-- 屏幕滚动: neoscroll
----------------------------------------

----------------------------------------
-- 光标移动: clever-f, hop, matchit
----------------------------------------
vim.opt.relativenumber = true
vim.api.nvim_set_keymap('c', '<C-a>', '<C-b>', { noremap = true })
-- vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true })
-- vim.api.nvim_set_keymap('v', '<C-e>', '$', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<C-e>', '$', { noremap = true })

----------------------------------------
-- 全文搜索: vim-visual-star-search, vim-cool, telescope, nvim-spectre
----------------------------------------
vim.api.nvim_set_keymap('n', '<BS>', '<CMD>nohl<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<CMD>nohl<CR><C-l>', { noremap = true })
vim.api.nvim_set_keymap('n', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('c', '<M-W>', "\\<\\><Left><Left>", { noremap = true })
vim.api.nvim_set_keymap('c', '<M-r>', "\\v", { noremap = true })
vim.api.nvim_set_keymap('c', '<M-c>', "\\C", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', '<CMD>Telescope current_buffer_fuzzy_find<CR>', { noremap = true })
-- NOTE: terminal map: ctrl+shift+f -> alt+f
vim.api.nvim_set_keymap('n', '<M-f>', '<CMD>Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-F>', '<CMD>Telescope live_grep<CR>', { noremap = true })

----------------------------------------
-- 标签跳转: vim-bookmarks, telescope-vim-bookmarks
----------------------------------------
-- NOTE: terminal map: ctrl+i -> alt+shift+i
vim.api.nvim_set_keymap('n', '<M-I>', '<C-i>', { noremap = true })
vim.api.nvim_set_keymap('n', '[h', "<CMD>Gitsigns next_hunk<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', ']h', "<CMD>Gitsigns prev_hunk<CR>", { noremap = true })

----------------------------------------
-- 插入编辑
----------------------------------------
vim.api.nvim_set_keymap('n', '<', '<<', { noremap = true })
vim.api.nvim_set_keymap('n', '>', '>>', { noremap = true })
-- NOTE: terminal map: ctrl+shift+j -> alt+shift+j
vim.api.nvim_set_keymap('i', '<M-J>', '<CMD>m .+1<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-J>', '<CMD>m .+1<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-S-J>', '<CMD>m .+1<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-J>', '<CMD>m .+1<CR><Cmd>normal ==<CR>', { noremap = true })
-- NOTE: terminal map: ctrl+shift+k -> alt+shift+k
vim.api.nvim_set_keymap('i', '<M-K>', '<CMD>m .-2<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-K>', '<CMD>m .-2<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-S-K>', '<CMD>m .-2<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-K>', '<CMD>m .-2<CR><Cmd>normal ==<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<End><CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<CMD>put =repeat(nr2char(10), v:count1)<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-k>', "repeat('<Del>', strchars(getline('.')) - getcurpos()[2] + 1)", { noremap = true, expr = true })
vim.api.nvim_set_keymap('c', '<C-k>', "repeat('<Del>', strchars(getcmdline()) - getcmdpos() + 1)", { noremap = true, expr = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<CMD>call C_Right()<CR><Right>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-l>', '<C-Right>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-z>', '<CMD>undo<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-r><C-r>', '<CMD>redo<CR>', { noremap = true })

----------------------------------------
-- 普通模式
----------------------------------------
vim.api.nvim_set_keymap('n', 'S', 'i<CR><Esc>', { noremap = true })

----------------------------------------
-- 复制粘贴
----------------------------------------
vim.opt.clipboard = '' -- lunarvim use system clipboard as default register, reset it
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
vim.api.nvim_set_keymap('v', '=p', '"0p', { noremap = true })
vim.api.nvim_set_keymap('n', '=p', '"0p', { noremap = true })
vim.api.nvim_set_keymap('n', '=P', '"0P', { noremap = true })
vim.api.nvim_set_keymap('n', '=o', '<CMD>put =@0<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '=O', '<CMD>put! =@0<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<Space>y', '"+y', { noremap = true })
vim.api.nvim_set_keymap('v', '<Space>p', '"+p', { noremap = true })
lvim.builtin.which_key.mappings["<Space>"] = { "<CMD>let @+ = @0<CR>", "Copy Register 0 to Clipboard" }
lvim.builtin.which_key.mappings["y"] = { '"+y', "Yank to Clipboard" }
lvim.builtin.which_key.mappings["Y"] = { '"+y$', "Yank All Right to Clipboard" }
lvim.builtin.which_key.mappings["p"] = { '"+p', "Paste Clipboard After Cursor" }
lvim.builtin.which_key.mappings["P"] = { '"+P', "Paste Clipboard Before Cursor" }
lvim.builtin.which_key.mappings["o"] = { "<CMD>put =@+<CR>", "Paste Clipboard to Next Line" }
lvim.builtin.which_key.mappings["O"] = { "<CMD>put! =@+<CR>", "Paste Clipboard to Previous Line" }
lvim.builtin.which_key.mappings["by"] = { "<CMD>%y +<CR>", "Yank Whole Buffer to Clipboard" }
lvim.builtin.which_key.mappings["bp"] = { "<CMD>%d<CR>\"+P", "Patse Clipboard to Whole Buffer" }

----------------------------------------
-- 文件操作: telescope
----------------------------------------
lvim.builtin.which_key.mappings["<Tab>"] = { ":try | b# | catch | endtry<CR>", "Switch Buffer" }
lvim.keys.normal_mode["<C-k>"] = false
vim.api.nvim_set_keymap('n', '<C-k><C-o>', '<CMD>Telescope projects<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>o', ":e <C-r>=fnamemodify(expand('%:p'), ':p:h')<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>n', '<CMD>enew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>r', '<CMD>Telescope oldfiles<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-p>', '<CMD>Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-s>', '<CMD>w<CR>', { noremap = true })
-- NOTE: terminal map: ctrl+shift+s -> alt+shift+s
vim.api.nvim_set_keymap('n', '<M-S>', ":saveas <C-r>=fnamemodify('.',':p')<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-S>', ":saveas <C-r>=fnamemodify('.',':p')<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>s', '<CMD>wa<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>x', '<CMD>BufferKill<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>u', ':try | %bd | catch | endtry<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>w', '<CMD>%bd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Tab>', '<CMD>wincmd w<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', '<CMD>wincmd W<CR>', { noremap = true })
lvim.builtin.which_key.mappings["q"] = { "<CMD>call SmartClose()<CR>", "Quit Cleverly" }

----------------------------------------
-- 语言服务
----------------------------------------
lvim.builtin.cmp.mapping["<C-j>"] = nil
lvim.builtin.cmp.mapping["<C-k>"] = nil
lvim.builtin.cmp.mapping["<C-e>"] = nil
lvim.builtin.cmp.mapping["<C-d>"] = nil
-- lvim.builtin.cmp.mapping["<CR>"] = nil
lvim.builtin.cmp.confirm_opts.select = true
local cmp = require("cmp")
local luasnip = require("luasnip")
local lccm = require("lvim.core.cmp").methods
-- NOTE: terminal map: ctrl+i -> alt+shift+i
lvim.builtin.cmp.mapping["<M-I>"] = cmp.mapping.complete()
lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
  if luasnip.expandable() then
    luasnip.expand()
  elseif cmp.visible() then
    cmp.confirm(lvim.builtin.cmp.confirm_opts)
  elseif lccm.jumpable() then
    luasnip.jump(1)
  elseif lccm.check_backspace() then
    fallback()
  elseif lccm.is_emmet_active() then
    return vim.fn["cmp#complete"]()
  else
    fallback()
  end
end, { "i", "s", }
)
vim.api.nvim_set_keymap('n', '<M-LeftMouse>', '<CMD>lua vim.lsp.buf.definition()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-F>', '<CMD>lua require("lvim.lsp.utils").format()<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<M-F>', '<CMD>lua require("lvim.lsp.utils").format()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<F2>', "<CMD>lua vim.lsp.buf.rename()<CR>", { noremap = true })
-- NOTE: terminal map: ctrl+. -> alt+.
vim.api.nvim_set_keymap('n', '<M-.>', '<CMD>lua vim.lsp.buf.code_action()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-.>', '<CMD>lua vim.lsp.buf.code_action()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-_>', 'gcc', {})
vim.api.nvim_set_keymap('i', '<C-_>', '<CMD>normal gcc<CR>', {})
vim.api.nvim_set_keymap('n', '<C-/>', 'gcc', {})
vim.api.nvim_set_keymap('i', '<C-/>', '<CMD>normal gcc<CR>', {})
vim.api.nvim_set_keymap('n', '<C-t>', '<CMD>Telescope lsp_workspace_symbols<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '[e', "<CMD>lua vim.diagnostic.goto_prev()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', ']e', "<CMD>lua vim.diagnostic.goto_next()<CR>", { noremap = true })

----------------------------------------
-- 其它按键: vim-translator, Calc, ...
----------------------------------------
-- NOTE: terminal map: ctrl+shift+e -> alt+shift+e
vim.api.nvim_set_keymap('n', '<M-E>', "<CMD>NvimTreeToggle<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-E>', "<CMD>NvimTreeToggle<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<M-e>', "<CMD>call Open_file_in_explorer()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<M-z>', "<CMD>let &wrap=!&wrap<CR>", { noremap = true })
lvim.builtin.which_key.mappings["sn"] = { "<CMD>lua require('telescope').extensions.notify.notify()<CR>", "Notifications" }
-- NOTE: terminal map: ctrl+shift+p -> alt+shift+p
vim.api.nvim_set_keymap('n', '<M-P>', "<CMD>Telescope commands<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-P>', "<CMD>Telescope commands<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k><C-s>', "<CMD>Telescope keymaps<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k><C-t>', "<Cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<CR>", { noremap = true })
lvim.builtin.which_key.mappings[";"] = nil
lvim.builtin.which_key.mappings["/"] = nil
lvim.builtin.which_key.mappings["w"] = nil
lvim.builtin.which_key.mappings["h"] = nil
lvim.builtin.which_key.mappings["f"] = nil
lvim.builtin.which_key.mappings["c"] = nil
lvim.builtin.which_key.mappings["e"] = nil
lvim.builtin.which_key.mappings["a"] = {
  name = "Application",
  e = { "<CMD>NvimTreeToggle<CR>", "Explorer" },
  o = { "<CMD>SymbolsOutline<CR>", "Outline" },
  t = { "<CMD>TodoTrouble<CR>", "TODO" },
  u = { "<CMD>UndotreeToggle<CR>", "UndoTree" },
  c = { "<CMD>Calc<CR>", "Calculator" },
}

----------------------------------------
-- Telescope
----------------------------------------
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<Esc>"] = actions.close,
    ["<C-b>"] = actions.preview_scrolling_up,
    ["<C-u>"] = nil
  },
  -- for normal mode
  n = {
  },
}

-- WARN: After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
----------------------------------------
-- User Config for predefined plugins
----------------------------------------
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.alpha.dashboard.section.buttons.entries[1][1] = "Ctrl+K n"
lvim.builtin.alpha.dashboard.section.buttons.entries[1][2] = "  New File"
lvim.builtin.alpha.dashboard.section.buttons.entries[1][3] = "<CMD>ene!<CR>"
lvim.builtin.alpha.dashboard.section.buttons.entries[2][1] = "Ctrl+P"
lvim.builtin.alpha.dashboard.section.buttons.entries[2][2] = "  Find File"
lvim.builtin.alpha.dashboard.section.buttons.entries[2][3] = "<CMD>Telescope find_files<CR>"
lvim.builtin.alpha.dashboard.section.buttons.entries[3][1] = "Ctrl+K Ctrl+O"
lvim.builtin.alpha.dashboard.section.buttons.entries[3][2] = "  Recent Projects "
lvim.builtin.alpha.dashboard.section.buttons.entries[3][3] = "<CMD>Telescope projects<CR>"
lvim.builtin.alpha.dashboard.section.buttons.entries[4][1] = "Ctrl+K r"
lvim.builtin.alpha.dashboard.section.buttons.entries[4][2] = "  Recently Used Files"
lvim.builtin.alpha.dashboard.section.buttons.entries[4][3] = "<CMD>Telescope oldfiles<CR>"
lvim.builtin.alpha.dashboard.section.buttons.entries[5][1] = "SPC S l"
lvim.builtin.alpha.dashboard.section.buttons.entries[5][2] = "  Restore Session"
lvim.builtin.alpha.dashboard.section.buttons.entries[5][3] = "<CMD>lua require('persistence').load({ last = true })<CR>"

lvim.builtin.notify.active = true

lvim.builtin.terminal.active = true
lvim.builtin.terminal.shell = "/bin/bash"
lvim.builtin.terminal.open_mapping = "<C-Space>"

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1

lvim.builtin.bufferline.options.always_show_bufferline = true

lvim.builtin.lualine.options.theme = "material"
lvim.builtin.lualine.options = {
  globalstatus       = true,
  section_separators = { left = '', right = ' ' },
}
local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_a = {
  { '', type = 'stl' }
}
lvim.builtin.lualine.sections.lualine_b = {
  {
    function()
      return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end,
    color = { bg = "#454c5a" },
    separator = { right = '' }
  },
  components.branch
}
lvim.builtin.lualine.sections.lualine_x = {
  components.diagnostics,
  { '', type = 'stl', color = { fg = "#454c5a" } }
}
lvim.builtin.lualine.sections.lualine_y = {
  components.treesitter,
  components.lsp,
  components.filetype,
  { "fileformat", color = { fg = "#bbbbbb" } },
}
lvim.builtin.lualine.sections.lualine_z = {
  { ' %l/%L  %c', type = 'stl' },
  components.scrollbar
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "vim",
  "lua",
  "c",
  "cpp",
  "cmake",
  "go",
  "python",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "markdown",
  "json",
  "yaml",
}


----------------------------------------
-- generic LSP settings
----------------------------------------

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---WARN: configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---WARN: remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

----------------------------------------
-- Additional Plugins
----------------------------------------
lvim.plugins = {
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-d>', '<C-u>', 'zz' },
        respect_scrolloff = true,
        easing_function = "circular", -- quadratic, cubic, quartic, quintic, circular, sine
      })
    end
  }, {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"
      vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard", "alpha", "packer" }
      vim.g.indent_blankline_buftype_exclude = { "terminal", "quickfix", "nofile", "help" }
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
    end
  }, {
    "rhysd/clever-f.vim",
    keys = { "f", "F", "t", "T" },
    setup = function()
      vim.g.clever_f_across_no_linew = 1
      vim.g.clever_f_smart_case = 1
      vim.g.clever_f_fix_key_direction = 1
    end
  }, {
    'phaazon/hop.nvim',
    cmd = "Hop*",
    branch = 'v1', -- optional but strongly recommended
    setup = function()
      vim.api.nvim_set_keymap("", ";", "<CMD>HopChar1<CR>", { noremap = true })
      vim.api.nvim_set_keymap("", ",", "<CMD>HopLineStartMW<CR>", { noremap = true })
    end,
    config = function()
      require("hop").setup({
        char2_fallback_key = "<Esc>"
      })
    end
  }, {
    "bronson/vim-visual-star-search",
    keys = { { "v", "*" }, { "v", "#" }, { "v", "g*" }, { "v", "g#" } },
  }, {
    "romainl/vim-cool",
    event = "CursorMoved"
  }, {
    "windwp/nvim-spectre",
    -- terminal map: ctrl+shift+h -> alt+shift+h
    keys = { "<M-H>" },
    config = function()
      require("spectre").setup({
        line_sep_start = '╭─────────────────────────────────────────────────────────',
        result_padding = '│  ',
        line_sep       = '╰─────────────────────────────────────────────────────────',
        mapping        = {
          ['run_replace'] = {
            -- terminal map: ctrl+alt+enter -> alt+enter
            map = "<M-CR>",
            cmd = "<CMD>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all"
          },
          ['toggle_ignore_case'] = {
            map = "<M-c>",
            cmd = "<CMD>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case"
          },
        }
      })
      vim.api.nvim_set_keymap('n', '<M-H>', ":lua require('spectre').open_visual({select_word=true})<CR>", { noremap = true, silent = true })
    end
  }, {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", },
        lastplace_open_folds = true,
      })
    end,
  }, {
    "MattesGroeger/vim-bookmarks",
    event = "BufRead",
    setup = function()
      vim.g.bookmark_sign = ''
      vim.g.bookmark_annotation_sign = ''
      vim.g.bookmark_display_annotation = 1
      vim.g.bookmark_auto_save_file = join_paths(get_cache_dir(), ".vim-bookmarks")
    end,
    config = function()
      vim.cmd [[hi link BookmarkSign SignColumn]]
      vim.cmd [[hi link BookmarkAnnotationSign SignColumn]]
      vim.api.nvim_set_keymap('n', 'ma', '', {})
      vim.api.nvim_set_keymap('n', 'mx', '', {})
      vim.api.nvim_set_keymap('n', 'mC', '<CMD>BookmarkClearAll<CR>', { noremap = true })
    end
  }, {
    "tom-anders/telescope-vim-bookmarks.nvim",
    keys = { "ml", "mL" },
    config = function()
      require('telescope').load_extension('vim_bookmarks')
      vim.api.nvim_set_keymap('n', 'ml', '<CMD>lua require("telescope").extensions.vim_bookmarks.current_file()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', 'mL', '<CMD>lua require("telescope").extensions.vim_bookmarks.all()<CR>', { noremap = true })
    end
  },
  { "terryma/vim-expand-region",
    keys = { { "v", "v" }, { "v", "V" } },
    config = function()
      vim.api.nvim_set_keymap('v', 'v', '<Plug>(expand_region_expand)', {})
      vim.api.nvim_set_keymap('v', 'V', '<Plug>(expand_region_shrink)', {})
    end
  },
  { 'kana/vim-textobj-user' },
  { 'kana/vim-textobj-entire' },
  { 'kana/vim-textobj-function' },
  { 'kana/vim-textobj-indent' },
  { 'kana/vim-textobj-line' },
  { 'sgur/vim-textobj-parameter' },
  { "tpope/vim-repeat" },
  {
    "tpope/vim-surround",
    keys = { "c", "d", "y" }
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
    setup = function()
      vim.api.nvim_set_keymap('n', '<M-s>', '<CMD>SudaWrite<CR>', { noremap = true })
    end
  }, {
    "benfowler/telescope-luasnip.nvim",
    keys = { "<M-i>" },
    config = function()
      require('telescope').load_extension('luasnip')
      vim.api.nvim_set_keymap('n', '<M-i>', "<CMD>lua require'telescope'.extensions.luasnip.luasnip{}<CR>", { noremap = true })
      vim.api.nvim_set_keymap('i', '<M-i>', "<CMD>lua require'telescope'.extensions.luasnip.luasnip{}<CR>", { noremap = true })
    end
  }, {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
      require "lsp_signature".setup()
    end
  }, {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    setup = function()
      vim.g.symbols_outline = {
        position = 'right',
        width = 20,
      }
      -- NOTE: terminal map: ctrl+shift+o -> alt+shift+o
      vim.api.nvim_set_keymap('n', '<M-O>', '<CMD>SymbolsOutline<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<C-S-O>', '<CMD>SymbolsOutline<CR>', { noremap = true })
    end
  }, {
    "folke/trouble.nvim",
    cmd = { "Trouble*" },
    setup = function()
      -- NOTE: terminal map: ctrl+shift+m -> alt+shift+m
      vim.api.nvim_set_keymap('n', '<M-M>', "<CMD>TroubleToggle<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<C-S-M>', "<CMD>TroubleToggle<CR>", { noremap = true })
    end
  }, {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    setup = function()
      lvim.builtin.which_key.mappings["S"] = {
        name = "Session",
        c = { "<CMD>lua require('persistence').load()<cr>", "Restore last session for current dir" },
        l = { "<CMD>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
        Q = { "<CMD>lua require('persistence').stop()<cr>", "Quit without saving session" },
      }
    end,
    config = function()
      require("persistence").setup {
        dir = join_paths(get_cache_dir(), "session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  }, {
    "voldikss/vim-translator",
    cmd = { "Translate*" },
    setup = function()
      vim.g.translator_default_engines = { 'bing', 'youdao' }
      vim.api.nvim_set_keymap('n', '<M-t>', '<CMD>TranslateW<CR>', { noremap = true })
      vim.api.nvim_set_keymap('v', '<M-t>', ':TranslateW<CR>', { noremap = true, silent = true })
      lvim.builtin.which_key.mappings["t"] = {
        name = "Translate",
        t = { "<Plug>Translate", "Echo translation in the cmdline" },
        w = { "<Plug>TranslateW", "Display translation in a window" },
        r = { "<Plug>TranslateR", "Replace the text with translation" },
      }
      lvim.builtin.which_key.vmappings["t"] = {
        name = "Translate",
        t = { "<Plug>TranslateV", "Echo translation in the cmdline" },
        w = { "<Plug>TranslateWV", "Display translation in a window" },
        r = { "<Plug>TranslateRV", "Replace the text with translation" },
      }
    end,
  }, {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "mg979/vim-visual-multi",
    keys = {
      { "n", "<C-n>" },
      { "v", "<C-n>" },
      { "n", "<M-L>" },
      { "v", "<M-L>" },
      { "n", "ma" },
      { "v", "ma" }
    },
    setup = function()
      vim.cmd [[
        " VM will override <BS>
        function! VM_Start()
          iunmap <buffer><Bs>
        endf
        function! VM_Exit()
          exe 'inoremap <buffer><expr><BS> v:lua.MPairs.autopairs_bs('.bufnr().')'
        endf
      ]]
    end,
    config = function()
      -- NOTE: terminal map: ctrl+shift+l -> alt+shift+l
      vim.api.nvim_set_keymap('n', '<M-L>', '<Plug>(VM-Select-All)', {})
      vim.api.nvim_set_keymap('v', '<M-L>', '<Plug>(VM-Visual-All)', {})
      vim.api.nvim_set_keymap('n', '<C-S-L>', '<Plug>(VM-Select-All)', {})
      vim.api.nvim_set_keymap('v', '<C-S-L>', '<Plug>(VM-Visual-All)', {})
      vim.api.nvim_set_keymap('n', 'ma', '<Plug>(VM-Add-Cursor-At-Pos)', {})
      vim.api.nvim_set_keymap('v', 'ma', '<Plug>(VM-Visual-Add)', {})
    end
  }, {
    "fedorenchik/VimCalc3",
    cmd = { "Calc" }
  }, {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  }, {
    "p00f/nvim-ts-rainbow"
  }, {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  }, {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" }
  }, {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    config = function()
      require("clangd_extensions").setup({
        server = {
          cmd = { "clangd", "--clang-tidy", "--enable-config" },
          on_attach = require("lvim.lsp").common_on_attach,
          on_init = require("lvim.lsp").common_on_init,
          on_exit = require("lvim.lsp").common_on_exit,
          capabilities = require("lvim.lsp").common_capabilities(),
        }
      })
    end
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.cmd [[
--   function! AutoOpenAlpha()
--     let bufs = getbufinfo({'buflisted':1})
--     let g:fuck_bufs = bufs
--     let g:fuck_bufnr = bufnr()
--     if len(bufs) == 1 && bufnr() == bufs[0].bufnr
--       Alpha
--     endif
--   endf
-- ]]
vim.cmd [[
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
]]
lvim.autocommands.custom_groups = {
  -- { "WinEnter", "*", [[call AutoOpenMinimap()]] }
  { "FileType", "c,cpp", [[nnoremap <buffer><M-o> <CMD>ClangdSwitchSourceHeader<CR>]] }
}
