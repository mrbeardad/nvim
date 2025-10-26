local banners = require("user.utils.banners")
local icons = require("user.utils.icons")
local utils = require("user.utils")

return {
  -- Startup page
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = banners.random_banner(),
          keys = {
            { icon = " ", key = "n", desc = "New File", action = "<Cmd>ene<Bar>startinsert<CR>" },
            { icon = " ", key = "r", desc = "Recent Files", action = "<Cmd>Telescope oldfiles<CR>" },
            { icon = "󰈞 ", key = "f", desc = "Find File", action = "<Cmd>Telescope find_files<CR>" },
            { icon = "󱎸 ", key = "/", desc = "Find Text", action = "<Cmd>Telescope egrepify<CR>" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = "<Cmd>exe 'Telescope find_files cwd='.stdpath('config')<CR>",
            },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              action = "<Cmd>lua require('persistence').load()<CR>",
            },
            { icon = " ", key = "p", desc = "Plugins", action = "<Cmd>Lazy<CR>" },
            { icon = " ", key = "q", desc = "Quit", action = "<Cmd>qa<CR>" },
          },
        },
      },
    },
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "User LazyDir",
    cmd = "Neotree",
    keys = {
      { "<Leader>e", "<Cmd>Neotree<CR>", desc = "Flie Explorer" },
      { "<Leader>be", "<Cmd>Neotree buffers<CR>", desc = "Buffer Explorer" },
      { "<Leader>ge", "<Cmd>Neotree git_status<CR>", desc = "Git Explorer" },
    },
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      source_selector = {
        winbar = true,
        show_scrolled_off_parent_node = true,
        sources = {
          { source = "filesystem" },
          { source = "git_status" },
          { source = "document_symbols" },
        },
      },
      open_files_do_not_replace_types = {
        "help",
        "quickfix",
        "terminal",
        "prompt",
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
        },
        modified = {
          symbol = icons.file.modified,
        },
        git_status = {
          symbols = {
            added = icons.diff.added,
            deleted = icons.diff.deleted,
            modified = icons.diff.modified,
            renamed = icons.diff.renamed,
          },
        },
      },
      window = {
        mappings = {
          ["<Space>"] = "noop",
          ["<"] = "noop",
          [">"] = "noop",
          ["H"] = "prev_source",
          ["L"] = "next_source",
          ["C"] = "noop",
          ["h"] = "close_node",
          ["l"] = "open",
        },
      },
      filesystem = {
        group_empty_dirs = true,
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["<CR>"] = "set_root",
            ["."] = "toggle_hidden",
            ["i"] = "noop",
            ["K"] = "show_file_details",
            ["c"] = {
              function(state)
                local node = state.tree:get_node()
                vim.fn.setreg("+", node.path)
              end,
              desc = "copy_path",
            },
            ["o"] = {
              function(state)
                local path = state.tree:get_node().path
                if vim.fn.isdirectory(path) == 0 then
                  path = vim.fs.dirname(path)
                end
                if utils.is_windows() then
                  os.execute("start " .. path)
                elseif utils.is_linux() then
                  os.execute("xdg-open " .. path)
                elseif utils.is_macos() then
                  os.execute("open " .. path)
                else
                  vim.notify("Unsupported System")
                end
              end,
              desc = "open_by_system",
            },
          },
        },
      },
    },
  },

  -- Show buffers and tabs at the top
  {
    "akinsho/bufferline.nvim",
    event = "User LazyFile",
    keys = {
      { "H", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
      { "L", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
      { "<Leader>`", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
      { "<Leader>bH", "<Cmd>BufferLineMovePrev<CR>", desc = "Move Buffer To Prev" },
      { "<Leader>bL", "<Cmd>BufferLineMoveNext<CR>", desc = "Move Buffer To Next" },
      { "<Leader>bD", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" },
      { "<Leader>bE", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" },
      { "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Unpinned Buffers" },
      { "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<Leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers To The Right" },
      { "<Leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers To The Left" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        close_command = function(bufnr)
          require("snacks").bufdelete.delete(bufnr)
        end,
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local diag_icons = icons.diagnostics
          local ret = (diag.error and diag_icons.error .. " " .. diag.error .. " " or "")
            .. (diag.warning and diag_icons.warn .. " " .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline on LazyFile
      vim.schedule(function()
        pcall(nvim_bufferline)
      end)
    end,
  },

  -- Statusline at the bottom
  {
    "nvim-lualine/lualine.nvim",
    event = "User LazyFile",
    opts = {
      options = {
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = icons.file.modified,
              readonly = icons.file.readonly,
              unnamed = icons.file.unnamed,
              newfile = icons.file.newfile,
            },
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.error .. " ",
              warn = icons.diagnostics.warn .. " ",
              info = icons.diagnostics.info .. " ",
              hint = icons.diagnostics.hint .. " ",
            },
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = "Statement",
          },
          {
            "diff",
            symbols = {
              added = icons.diff.added .. " ",
              modified = icons.diff.modified .. " ",
              removed = icons.diff.deleted .. " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = { "filetype", "fileformat", "encoding" },
        lualine_z = { { " %c  %l:%L", type = "stl" } },
      },
      extensions = { "quickfix", "lazy", "neo-tree" },
    },
  },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "User LazyFile",
    opts = {
      hide_if_all_visible = true,
      handle = {
        highlight = "ScrollbarHandle",
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        search = true, -- Requires hlslens
      },
      marks = {
        Cursor = { text = "—" },
        Search = { text = { "—", "󰇼" } },
        Error = { text = { "—", "󰇼" } },
        Warn = { text = { "—", "󰇼" } },
        Info = { text = { "—", "󰇼" } },
        Hint = { text = { "—", "󰇼" } },
        Misc = { text = { "—", "󰇼" } },
        GitAdd = { text = "▎" },
        GitChange = { text = "▎" },
        GitDelete = { text = "▁" },
      },
    },
  },

  -- Smooth scroll
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
    },
  },

  -- Show context of the current cursor position
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "User LazyFile",
    keys = {
      {
        "[[",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = { "n", "x" },
      },
    },
    opts = {
      max_lines = vim.o.scrolloff,
    },
  },

  -- Show keymaps help when press
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<Leader><Tab>", group = "Switch Buffer" },
          { "<Leader>b", group = "Buffer" },
          { "<Leader>g", group = "Git" },
          { "<Leader>l", group = "Language" },
          { "<Leader>m", group = "Multi Cursor" },
          { "<Leader>n", group = "Noice Message" },
          { "<Leader>q", group = "Quit/Session" },
          { "<Leader>s", group = "Search" },
          { "<Leader>t", group = "Tabs" },
          { "<Leader>u", group = "UI" },
          { "[", group = "Prev" },
          { "]", group = "Next" },
          { "g", group = "Goto" },
        },
      },
    },
  },

  -- Search and preview
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   dependencies = {
  --     {
  --       "nvim-telescope/telescope-fzf-native.nvim",
  --       build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  --     },
  --   },
  --   cmd = "Telescope",
  --   keys = {
  --     -- Buffers
  --     {
  --       "<Leader><Tab>",
  --       "<Cmd>Telescope buffers sort_mru=true sort_lastused=true theme=dropdown<CR>",
  --       desc = "Switch Buffers",
  --     },
  --     -- Files
  --     { "<Leader>f", "<Cmd>Telescope find_files<CR>", desc = "Find Files" },
  --     { "<Leader>r", "<Cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
  --     { "<Leader>R", "<Cmd>Telescope oldfiles cwd_only=true<CR>", desc = "Recent Files In Cwd" },
  --     -- Text
  --     { "<Leader>sw", "<Cmd>Telescope grep_string<CR>", desc = "Word" },
  --     {
  --       "<Leader>sw",
  --       function()
  --         local text = table.concat(utils.get_visual_text())
  --         require("telescope.builtin").grep_string({ search = text })
  --       end,
  --       mode = "x",
  --       desc = "Word",
  --     },
  --     -- Lsp
  --     { "<Leader>sd", "<Cmd>Telescope diagnostics bufnr=0<CR>", desc = "Document Diagnostics" },
  --     { "<Leader>sD", "<Cmd>Telescope diagnostics<CR>", desc = "Workspace Diagnostics" },
  --     {
  --       "<Leader>ss",
  --       function()
  --         local kf = require("user.utils.lsp").kind_filter
  --         kf = kf[vim.bo.filetype] or kf.default
  --         require("telescope.builtin").lsp_document_symbols({
  --           symbols = kf,
  --         })
  --       end,
  --       desc = "Document Symbol",
  --     },
  --     {
  --       "<Leader>sS",
  --       function()
  --         local kf = require("user.utils.lsp").kind_filter
  --         kf = kf[vim.bo.filetype] or kf.default
  --         require("telescope.builtin").lsp_dynamic_workspace_symbols({
  --           symbols = kf,
  --         })
  --       end,
  --       desc = "Workspace Symbols",
  --     },
  --     { "gd", "<Cmd>Telescope lsp_definitions reuse_win=true<CR>", desc = "Goto Definition" },
  --     { "gt", "<Cmd>Telescope lsp_type_definitions reuse_win=true<CR>", desc = "Goto Type Definition" },
  --     { "gr", "<Cmd>Telescope lsp_references<CR>", desc = "Goto References" },
  --     { "gi", "<Cmd>Telescope lsp_implementations reuse_win=true<CR>", desc = "Goto Implementation" },
  --     -- Others
  --     { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Command History" },
  --     { "<Leader>?", "<cmd>Telescope help_tags<CR>", desc = "Help Pages" },
  --     { "<Leader>sc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
  --     { "<Leader>sa", "<Cmd>Telescope autocommands<CR>", desc = "Auto Commands" },
  --     { "<Leader>sb", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Fuzzy Search" },
  --     { "<Leader>sl", "<cmd>Telescope highlights<CR>", desc = "highlights" },
  --     { "<Leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Key Maps" },
  --     { "<Leader>sm", "<cmd>Telescope marks<CR>", desc = "Jump To Mark" },
  --     { "<Leader>so", "<cmd>Telescope vim_options<CR>", desc = "Options" },
  --     { "<Leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume" },
  --   },
  --   opts = {
  --     defaults = {
  --       sorting_strategy = "ascending",
  --       winblend = vim.o.winblend,
  --       layout_config = {
  --         horizontal = {
  --           prompt_position = "top",
  --           -- mirror = true,
  --           width = 0.9,
  --           preview_width = 0.5,
  --         },
  --       },
  --       path_display = function(opts, path)
  --         local prefix = vim.uv.cwd()
  --         local plen = #prefix
  --         local start = utils.is_windows() and 3 or 1
  --         if string.sub(path, start, plen) == prefix:sub(start) then
  --           -- remove prefix + \
  --           local highlight = {
  --             {
  --               {
  --                 0, -- highlight start position
  --                 #path - plen - 1, -- highlight end position
  --               },
  --               "Directory", -- highlight group name
  --             },
  --           }
  --           return string.sub(path, plen + 2), highlight
  --         end
  --         return path
  --       end,
  --       prompt_prefix = " ",
  --       selection_caret = " ",
  --       file_ignore_patterns = {},
  --       get_selection_window = function()
  --         return vim.g.last_normal_win
  --       end,
  --       mappings = {
  --         i = {
  --           ["<Esc>"] = "close",
  --           ["<C-F>"] = "preview_scrolling_down",
  --           ["<C-B>"] = "preview_scrolling_up",
  --           ["<M-f>"] = "preview_scrolling_right",
  --           ["<M-b>"] = "preview_scrolling_left",
  --           ["<Up>"] = "cycle_history_prev",
  --           ["<Down>"] = "cycle_history_next",
  --           ["<C-V>"] = false,
  --           ["<C-U>"] = false,
  --           ["<C-K>"] = false,
  --         },
  --       },
  --     },
  --     extensions = {
  --       egrepify = {
  --         AND = false,
  --         prefixes = {
  --           ["!"] = {
  --             flag = "invert-match",
  --           },
  --           ["\\C"] = {
  --             flag = "case-sensitive",
  --           },
  --         },
  --         mappings = {
  --           i = {
  --             ["<C-z>"] = false,
  --             ["<C-a>"] = false,
  --             ["<C-r>"] = false,
  --           },
  --         },
  --       },
  --       undo = {
  --         side_by_side = true,
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("telescope").setup(opts)
  --     require("telescope").load_extension("fzf")
  --   end,
  -- },
  -- -- Better live_grep that could change rg arguments on fly
  -- {
  --   "fdschmidt93/telescope-egrepify.nvim",
  --   keys = {
  --     { "<Leader>/", "<Cmd>Telescope egrepify<CR>", desc = "Search Text" },
  --     {
  --       "<Leader>/",
  --       function()
  --         local text = table.concat(utils.get_visual_text()):gsub(" ", "\\ ")
  --         vim.cmd("Telescope egrepify default_text=" .. text)
  --       end,
  --       mode = "x",
  --       desc = "Search Text",
  --     },
  --   },
  --   config = function()
  --     require("telescope").load_extension("egrepify")
  --   end,
  -- },
  -- -- Undo history
  -- {
  --   "debugloop/telescope-undo.nvim",
  --   keys = { { "<Leader>su", "<Cmd>Telescope undo<CR>", desc = "Undo History" } },
  --   config = function()
  --     require("telescope").load_extension("undo")
  --   end,
  -- },

  {
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
    },
    -- stylua: ignore
        keys = {
          { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
          -- { "<leader>/", LazyVim.pick("grep"), desc = "Grep (Root Dir)" },
          { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
          -- { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
          { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
          -- find
          { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
          { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
          -- { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
          -- { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
          -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
          { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
          -- { "<leader>fr", LazyVim.pick("oldfiles"), desc = "Recent" },
          { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
          { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
          -- git
          { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
          { "<leader>gD", function() Snacks.picker.git_diff({ base = "origin" }) end, desc = "Git Diff (origin)" },
          { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
          { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
          -- Grep
          { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
          { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
          -- { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
          -- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
          { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
          -- { "<leader>sw", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
          -- { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
          -- search
          { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
          { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
          { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
          { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
          { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
          { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
          { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
          { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
          { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
          { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
          { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
          { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
          { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
          { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
          { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
          { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
          { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
          { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
          -- ui
          { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    }
  },

  -- Better ui components for neovim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<C-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<Leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<Leader>nh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<Leader>na",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<Leader>nd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<C-F>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-F>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<C-B>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-B>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
    init = function()
      vim.opt.cmdheight = 0
    end,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
}
