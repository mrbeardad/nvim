local icons = require("user.utils.icons")

return {
  -- Startup page
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    init = function()
      -- Hide statusline during startup, the statusline plugin will reset it later
      vim.opt.laststatus = 0
    end,
    opts = function()
      -- Header
      local dashboard = require("alpha.themes.dashboard")
      local banners = require("user.utils.banners")
      math.randomseed(os.time())
      local banner = vim.split(banners[math.random(#banners)], "\n")
      dashboard.section.header.val = banner
      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", "<Cmd>ene<Bar>startinsert<CR>"),
        dashboard.button("/", "󱎸  Find Text", "<Cmd>Telescope egrepify<CR>"),
        dashboard.button("f", "󰈞  Find File", "<Cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", "<Cmd>Telescope oldfiles<CR>"),
        dashboard.button("c", "  Config Files", "<Cmd>exe 'Telescope find_files cwd='.stdpath('config')<CR>"),
        dashboard.button("s", "󰦛  Restore Session", "<Cmd>lua require('persistence').load()<CR>"),
        dashboard.button("p", "  Plugins", "<Cmd>Lazy<CR>"),
        dashboard.button("q", "  Quit", "<Cmd>qa<CR>"),
      }
      -- Footer
      vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          dashboard.section.footer.val =
            string.format("⚡ Neovim loaded %d/%d plugins in %.2f ms", stats.loaded, stats.count, stats.startuptime)
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
      -- Vertical center the header
      local remain_height = vim.api.nvim_win_get_height(0) - #banner - #dashboard.section.buttons.val * 2 - 2
      remain_height = remain_height > 0 and remain_height or 0
      dashboard.opts.layout[1].val = math.ceil(remain_height / 2)
      dashboard.opts.layout[3].val = math.floor(remain_height / 2)
      -- Highlight
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      return dashboard.opts
    end,
    config = function(_, opts)
      -- Close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(opts)
    end,
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
      open_files_do_not_replace_types = { "help", "quickfix", "terminal", "prompt" },
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
          ["<Tab>"] = {
            function()
              local Preview = require("neo-tree.sources.common.preview")
              if Preview.is_active() then
                Preview.focus()
              else
                vim.fn.win_gotoid(vim.g.last_normal_win)
              end
            end,
            desc = "focus_preview",
          },
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
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                vim.fn.setreg("+", node.path)
              end,
              desc = "yank_path",
            },
            ["O"] = {
              function(state)
                local utils = require("user.utils")
                local node = state.tree:get_node()
                if utils.is_windows() then
                  os.execute("start " .. node.path)
                elseif utils.is_linux() then
                  os.execute("xdg-open " .. node.path)
                elseif utils.is_macos() then
                  os.execute("open " .. node.path)
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
    config = function(_, opts)
      require("neo-tree").setup(opts)
      local neotree_utils = require("neo-tree.utils")
      -- Fix the bug on windows https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1264
      ---@diagnostic disable-next-line
      neotree_utils.escape_path = function(path)
        local escaped_path = vim.fn.fnameescape(path) or path
        if neotree_utils.is_windows then
          escaped_path = escaped_path:gsub("/", "\\")
        end
        return escaped_path
      end
    end,
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
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
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
      extensions = { "lazy", "neo-tree" },
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

  -- Animate scroll
  {
    "karb94/neoscroll.nvim",
    keys = {
      { "<C-y>", mode = { "n", "x" } },
      { "<C-e>", mode = { "n", "x" } },
      { "<C-u>", mode = { "n", "x" } },
      { "<C-d>", mode = { "n", "x" } },
      { "<C-b>", mode = { "n", "x" } },
      { "<C-f>", mode = { "n", "x" } },
      { "zt", mode = { "n", "x" } },
      { "zz", mode = { "n", "x" } },
      { "zb", mode = { "n", "x" } },
      { "z<CR>", "zt", mode = { "n", "x" }, remap = true },
    },
    opts = {
      easing_function = "quartic",
    },
  },

  -- Show context of the current cursor position
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "User LazyFile",
    opts = {
      max_lines = 3,
    },
  },

  -- Show keymaps help when press
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        presets = {
          operators = false,
        },
      },
      -- Delete < and >
      operators = {
        d = "Delete",
        c = "Change",
        y = "Yank",
        ["g~"] = "Toggle Case",
        ["gu"] = "Lowercase",
        ["gU"] = "Uppercase",
        ["zf"] = "Create Fold",
        ["!"] = "Filter Through External Program",
        ["v"] = "Visual Character Mode",
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").register({
        mode = { "n", "x" },
        ["g"] = { name = "+Goto" },
        ["]"] = { name = "+Next" },
        ["["] = { name = "+Prev" },
        ["<Leader><Tab>"] = { name = "+Switch Buffer" },
        ["<Leader>b"] = { name = "+Buffer" },
        ["<Leader>t"] = { name = "+Tabs" },
        ["<Leader>q"] = { name = "+Quit/Session" },
        ["<Leader>s"] = { name = "+Search" },
        ["<Leader>n"] = { name = "+Noice Message" },
        ["<Leader>l"] = { name = "+Language" },
        ["<Leader>g"] = { name = "+Git" },
        ["<Leader>u"] = { name = "+UI" },
        ["<Leader>p"] = { name = "+Package Managers" },
      })
    end,
  },

  -- Search and preview
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    cmd = "Telescope",
    keys = {
      -- Buffers
      {
        "<Leader><Tab>",
        "<Cmd>Telescope buffers sort_mru=true sort_lastused=true theme=dropdown<CR>",
        desc = "Switch Buffers",
      },
      -- Files
      { "<Leader>f", "<Cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<Leader>r", "<Cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
      { "<Leader>R", "<Cmd>Telescope oldfiles cwd_only=true<CR>", desc = "Recent Files In Cwd" },
      -- Text
      { "<Leader>sw", "<Cmd>Telescope grep_string<CR>", desc = "Word" },
      -- Lsp
      { "<Leader>sd", "<Cmd>Telescope diagnostics bufnr=0<CR>", desc = "Document Diagnostics" },
      { "<Leader>sD", "<Cmd>Telescope diagnostics<CR>", desc = "Workspace Diagnostics" },
      {
        "<Leader>ss",
        function()
          local kf = require("user.utils.lsp").kind_filter
          kf = kf[vim.bo.filetype] or kf.default
          require("telescope.builtin").lsp_document_symbols({
            symbols = kf,
          })
        end,
        desc = "Document Symbol",
      },
      {
        "<Leader>sS",
        function()
          local kf = require("user.utils.lsp").kind_filter
          kf = kf[vim.bo.filetype] or kf.default
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = kf,
          })
        end,
        desc = "Workspace Symbols",
      },
      { "gd", "<Cmd>Telescope lsp_definitions reuse_win=true<CR>", desc = "Goto Definition" },
      { "gt", "<Cmd>Telescope lsp_type_definitions reuse_win=true<CR>", desc = "Goto Type Definition" },
      { "gr", "<Cmd>Telescope lsp_references<CR>", desc = "Goto References" },
      { "gi", "<Cmd>Telescope lsp_implementations reuse_win=true<CR>", desc = "Goto Implementation" },
      -- Others
      { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Command History" },
      { "<Leader>sC", "<Cmd>Telescope command_history<CR>", desc = "Command History" },
      { "<Leader>sc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
      { "<Leader>sa", "<Cmd>Telescope autocommands<CR>", desc = "Auto Commands" },
      { "<Leader>sb", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Fuzzy Search" },
      { "<Leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Pages" },
      { "<Leader>sl", "<cmd>Telescope highlights<CR>", desc = "highlights" },
      { "<Leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Key Maps" },
      { "<Leader>sm", "<cmd>Telescope marks<CR>", desc = "Jump To Mark" },
      { "<Leader>so", "<cmd>Telescope vim_options<CR>", desc = "Options" },
      { "<Leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume" },
    },
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        winblend = vim.o.winblend,
        layout_config = {
          horizontal = {
            prompt_position = "top",
            -- mirror = true,
            width = 0.9,
            preview_width = 0.45,
          },
        },
        path_display = {
          -- "smart",
          "truncate",
        },
        prompt_prefix = " ",
        selection_caret = " ",
        file_ignore_patterns = {},
        get_selection_window = function()
          return vim.g.last_normal_win
        end,
        mappings = {
          i = {
            ["<Esc>"] = "close",
            ["<C-f>"] = "preview_scrolling_down",
            ["<C-b>"] = "preview_scrolling_up",
            ["<A-f>"] = "preview_scrolling_right",
            ["<A-b>"] = "preview_scrolling_left",
            ["<Up>"] = "cycle_history_prev",
            ["<Down>"] = "cycle_history_next",
            ["<C-v>"] = false,
            ["<C-u>"] = false,
            ["<C-k>"] = false,
          },
        },
      },
      extensions = {
        egrepify = {
          AND = false,
          prefixes = {
            ["!"] = {
              flag = "invert-match",
            },
          },
          mappings = {
            i = {
              ["<C-z>"] = false,
              ["<C-a>"] = false,
              ["<C-r>"] = false,
            },
          },
        },
        undo = {
          side_by_side = true,
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },
  -- Better live_grep that could change rg arguments on fly
  {
    "fdschmidt93/telescope-egrepify.nvim",
    keys = {
      { "<Leader>/", "<Cmd>Telescope egrepify<CR>", desc = "Search Text" },
      { "<Leader>sg", "<Cmd>Telescope egrepify<CR>", desc = "Grep Text" },
    },
    config = function()
      require("telescope").load_extension("egrepify")
    end,
  },
  -- Undo history
  {
    "debugloop/telescope-undo.nvim",
    keys = { { "<Leader>su", "<Cmd>Telescope undo<CR>", desc = "Undo History" } },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },

  -- Better ui components for neovim
  {
    "folke/noice.nvim",
    enabled = false,
    dependencies = {
      {
        "rcarriga/nvim-notify",
        keys = {
          {
            "<leader>un",
            function()
              require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Dismiss all Notifications",
          },
        },
        opts = {},
      },
    },
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<C-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<Leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<Leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<Leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<Leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<C-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<C-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
    init = function()
      vim.opt.cmdheight = 0
    end,
    opts = {
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
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
