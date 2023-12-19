local utils = require("user.utils")
local icons = require("user.utils.icons")
local banners = require("user.utils.banners")

return {
  -- startup page
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    init = function()
      -- disable statusline during startup, then statusline plugin will reset it
      vim.opt.laststatus = 0
    end,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      math.randomseed(os.time())
      local banner = vim.split(banners[math.random(#banners)], "\n")
      dashboard.section.header.val = banner
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", "<Cmd>ene<Bar>startinsert<CR>"),
        dashboard.button("/", "󱎸  Find Text", "<Cmd>Telescope egrepify<CR>"),
        dashboard.button("f", "󰈞  Find File", "<Cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", "<Cmd>Telescope oldfiles<CR>"),
        dashboard.button("c", "  Config Files", "<Cmd>exe 'Telescope find_files cwd='.stdpath('config')<CR>"),
        dashboard.button("s", "󰦛  Restore Session", "<Cmd>lua require('persistence').load()<CR>]]"),
        dashboard.button("l", "  Plugins", "<Cmd>Lazy<CR>"),
        dashboard.button("q", "  Quit", "<Cmd>qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      -- center the banner
      local remain_height = vim.api.nvim_win_get_height(0) - #banner - #dashboard.section.buttons.val * 2 - 2
      remain_height = remain_height > 0 and remain_height or 0
      dashboard.opts.layout[1].val = math.ceil(remain_height / 2)
      dashboard.opts.layout[3].val = math.floor(remain_height / 2)
      vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
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

      require("alpha").setup(dashboard.opts)
    end,
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "User LazyDir",
    cmd = "Neotree",
    keys = { { "<Leader>e", "<Cmd>Neotree<CR>", desc = "Explorer" } },
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
      open_files_do_not_replace_types = { "acwrite", "help", "nofile", "nowrite", "quickfix", "terminal", "prompt" },
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
          ["<"] = "noop",
          [">"] = "noop",
          ["H"] = "prev_source",
          ["L"] = "next_source",
        },
      },
      filesystem = {
        group_empty_dirs = true,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["<CR>"] = "set_root",
            ["."] = "toggle_hidden",
            ["[g"] = "noop",
            ["]g"] = "noop",
            ["[c"] = "prev_git_modified",
            ["]c"] = "prev_git_modified",
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
  },

  -- show buffers and tabs
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
      { "<Leader>be", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" },
      { "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-pinned Buffers" },
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
      -- fix bufferline on LazyFile
      vim.schedule(function()
        pcall(nvim_bufferline)
      end)
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "User LazyFile",
    opts = {
      options = {
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "filename",
            symbols = {
              modified = icons.file.modified,
              readonly = icons.file.readonly,
              unnamed = icons.file.unnamed,
              newfile = icons.file.newfile,
            },
          },
        },
        lualine_c = {
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
        lualine_x = {
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
        lualine_y = { "filetype", "fileformat", "encoding" },
        lualine_z = { { " %c  %l:%L", type = "stl" } },
      },
      extensions = { "lazy", "neo-tree" },
    },
  },

  -- show keymaps when press
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").register({
        ["<Tab>"] = { name = "Switch Buffer" },
        b = { name = "Buffer" },
        f = { name = "File" },
        g = { name = "Git" },
        l = { name = "Language" },
        p = { name = "Package Managers" },
        q = { name = "Quit/Session" },
        s = { name = "Search" },
        t = { name = "Tab" },
        u = { name = "UI Toggle" },
      }, { prefix = "<Leader>" })
    end,
  },

  -- search and preview
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
      -- buffers
      {
        "<Leader><Tab>",
        "<Cmd>Telescope buffers sort_mru=true sort_lastused=true theme=dropdown<CR>",
        desc = "Switch Buffers",
      },
      -- files
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Files" },
      { "<Leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
      { "<Leader>fR", "<Cmd>Telescope oldfiles cwd_only=true<CR>", desc = "Recent Files In Cwd" },
      { "<Leader>fc", "<Cmd>exe 'Telescope find_files cwd='.stdpath('config')<CR>", desc = "Files" },
      -- text
      { "<Leader>sw", "<Cmd>Telescope grep_string<CR>", desc = "Word" },
      -- lsp
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
        "<leader>sS",
        function()
          local kf = require("user.utils.lsp").kind_filter
          kf = kf[vim.bo.filetype] or kf.default
          require("telescope.builtin").lsp_workspace_symbols({
            symbols = kf,
          })
        end,
        desc = "Workspace Symbols",
      },
      { "gd", "<Cmd>Telescope lsp_definitions reuse_win=true<CR>", desc = "Goto Definition" },
      { "gt", "<Cmd>Telescope lsp_type_definitions reuse_win=true<CR>", desc = "Goto Type Definition" },
      { "gr", "<Cmd>Telescope lsp_references<CR>", desc = "Goto References" },
      { "gi", "<Cmd>Telescope lsp_implementations reuse_win=true<CR>", desc = "Goto Implementation" },
      -- others
      { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Command History" },
      { "<Leader>sa", "<Cmd>Telescope autocommands<CR>", desc = "Auto Commands" },
      { "<Leader>sb", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Fuzzy Search" },
      { "<Leader>sc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
      { "<Leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Pages" },
      { "<Leader>sl", "<cmd>Telescope highlights<CR>", desc = "highlights" },
      { "<Leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Key Maps" },
      { "<Leader>sm", "<cmd>Telescope marks<CR>", desc = "Jump To Mark" },
      { "<Leader>so", "<cmd>Telescope vim_options<CR>", desc = "Options" },
      { "<Leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume" },
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.5,
            },
          },
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = {},
          get_selection_window = function()
            return vim.g.last_normal_win
          end,
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<A-f>"] = actions.preview_scrolling_right,
              ["<A-b>"] = actions.preview_scrolling_left,
              ["<Up>"] = actions.cycle_history_prev,
              ["<Down>"] = actions.cycle_history_next,
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
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "fdschmidt93/telescope-egrepify.nvim",
    keys = {
      { "<leader>/", "<Cmd>Telescope egrepify<CR>", desc = "Search Text" },
    },
    config = function()
      require("telescope").load_extension("egrepify")
    end,
  },
}
