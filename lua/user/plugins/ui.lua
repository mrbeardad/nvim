local utils = require("user.utils")
local icons = require("user.utils.icons")
local banners = require("user.utils.banners")

return {
  -- startup page
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      math.randomseed(os.time())
      local banner = banners[math.random(#banners)]
      local opts = {
        theme = "doom",
        config = {
          header = vim.split(banner, "\n"),
          -- stylua: ignore
          center = {
            { action = "ene | startinsert",                                 desc = " New File",        icon = " ", key = "n" },
            { action = "Telescope find_files",                              desc = " Find File",       icon = " ", key = "f" },
            { action = "Telescope oldfiles",                                desc = " Recent Files",    icon = " ", key = "r" },
            { action = "exe 'Telescope find_files cwd='.stdpath('config')", desc = " Config Files",    icon = " ", key = "c" },
            { action = "Telescope egrepify",                                desc = " Search Text",     icon = "󱎸 ", key = "/" },
            { action = 'lua require("persistence").load()',                 desc = " Restore Session", icon = "󰦛 ", key = "s" },
            { action = "Lazy",                                              desc = " Plugins",         icon = " ", key = "p" },
            { action = "qa",                                                desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "User LazyDir",
    cmd = "Neotree",
    keys = {
      { "<Leader>e", "<Cmd>Neotree<CR>", desc = "Explorer" },
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
              desc = "Open by System",
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
      { "<Leader>bP", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<Leader>bD", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-pinned Buffers" },
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
    opts = {},
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").register({
        ["<Tab>"] = { name = "Switch Buffer" },
        b = { name = "Buffer" },
        f = { name = "File" },
        l = { name = "Language" },
        p = { name = "Package Managers" },
        t = { name = "Tab" },
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
      { "<Leader><Tab>", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Switch Buffers" },
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
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
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
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>/", "<Cmd>Telescope egrepify<CR>", desc = "Search Text" },
    },
    config = function()
      require("telescope").load_extension("egrepify")
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "User LazyFile",
    opts = {
      handlers = {
        cursor = false,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        search = true, -- Requires hlslens
      },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "User LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local function goto_change(next)
          return function()
            if vim.wo.diff then
              return next and "]c" or "[c"
            end
            vim.schedule(function()
              require("gitsigns")[next and "next_hunk" or "prev_hunk"]()
            end)
            return "<Ignore>"
          end
        end

        -- stylua: ignore start
        map("n", "]c", goto_change(true), "Next Hunk")
        map("n", "[c", goto_change(), "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    "kevinhwang91/nvim-hlslens",
    event = "CmdlineEnter",
    keys = {
      {
        "n",
        [[<Cmd>execute("normal! " . v:count1 . "Nn"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Repeat last search in forward direction",
      },
      {
        "N",
        [[<Cmd>execute("normal! " . v:count1 . "nN"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Repeat last search in backward direction",
      },
      {
        "*",
        [[*<Cmd>lua require("hlslens").start()<CR>]],
        desc = "Search forward for nearest word (match word)",
      },
      {
        "#",
        [[#<Cmd>lua require("hlslens").start()<CR>]],
        desc = "Search forward for nearest word (match word)",
      },
      {
        "g*",
        [[g*<Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Search forward for nearest word",
      },
      {
        "g#",
        [[g#<Cmd>lua require("hlslens").start()<CR>]],
        mode = { "n", "x" },
        desc = "Search backward for nearest word",
      },
    },
    opts = {
      calm_down = true,
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
        else
          indicator = ""
        end
        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= "" then
            text = ("[%s %d/%d]"):format(indicator, idx, cnt)
          else
            text = ("[%d/%d]"):format(idx, cnt)
          end
          chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
        else
          text = ("[%s %d]"):format(indicator, idx)
          chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    },
    config = function(_, opts)
      require("hlslens").setup(opts)
      if vim.g.vscode then
        -- To clear and redraw in vscode
        require("hlslens.lib.event"):on("LensUpdated", function()
          vim.cmd("mode")
        end, {})
        -- TODO: vscode colorscheme
        vim.cmd("hi HlSearchLensNear guibg=#40bf6a guifg=#062e32")
        vim.cmd("hi HlSearchLens guibg=#0a5e69 guifg=#b2cac3")
      end
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "User LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {},
    },
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    event = "User LazyFile",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "BufEnterSpecial",
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- highlight word under cursor
  {
    "echasnovski/mini.cursorword",
    opts = {
      delay = vim.o.timeoutlen,
    },
  },
}
