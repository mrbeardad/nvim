local Util = require("lazyvim.util")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "User LazyDir",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ dir = Util.root() })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    opts = {
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
        modified = {
          symbol = "●",
        },
        git_status = {
          symbols = {
            ignored = "",
            added = "",
            modified = "",
            renamed = "",
            deleted = "",
          },
        },
      },
      window = {
        mappings = {
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
                local sysname = vim.loop.os_uname().sysname
                local node = state.tree:get_node()
                if sysname:find("Windows") then
                  os.execute("start " .. node.path)
                elseif sysname == "Linux" then
                  os.execute("xdg-open " .. node.path)
                elseif sysname == "Darwin" then
                  os.execute("open " .. node.path)
                else
                  require("lazy.core.util").warn("Unsupported System")
                end
              end,
              desc = "open_by_system",
            },
          },
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- buffers
      { "<Leader>,", false },
      {
        "<Leader><Tab>",
        "<Cmd>Telescope buffers sort_mru=true sort_lastused=true theme=dropdown<CR>",
        desc = "Switch Buffers",
      },
      -- use egrepify instead
      { "<Leader>/", false },
    },
    opts = {
      defaults = {
        winblend = vim.o.winblend,
        sorting_strategy = "ascending",
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
        -- prompt_prefix = " ",
        file_ignore_patterns = {},
        get_selection_window = function()
          return vim.g.last_normal_win
        end,
        mappings = {
          i = {
            ["<Esc>"] = "close",
            ["<A-f>"] = "preview_scrolling_right",
            ["<A-b>"] = "preview_scrolling_left",
            ["<Up>"] = "cycle_history_prev",
            ["<Down>"] = "cycle_history_next",
            ["<C-Down>"] = false,
            ["<C-Up>"] = false,
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
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    enabled = true,
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "fdschmidt93/telescope-egrepify.nvim",
    keys = {
      { "<Leader>/", "<Cmd>Telescope egrepify<CR>", desc = "Search Text" },
    },
    config = function()
      require("telescope").load_extension("egrepify")
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    keys = { { "<Leader>su", "<Cmd>Telescope undo<CR>", desc = "Undo History" } },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },

  {
    "folke/flash.nvim",
    event = function()
      return {}
    end,
    keys = {
      { "s", false, mode = { "n", "x", "o" } },
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      { "r", "<Cmd>lua require('flash').remote({restore=true})<CR>", mode = "o", desc = "Flash Remote" },
      {
        ";",
        "<Cmd>lua require('flash').treesitter({jump={pos='start'}})<CR>",
        mode = { "n", "o", "x" },
        desc = "Outter Start Of Treesitter Node",
      },
      {
        ",",
        "<Cmd>lua require('flash').treesitter({jump={pos='end'}})<CR>",
        mode = { "n", "o", "x" },
        desc = "Outter Start Of Treesitter Node",
      },
    },
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm1234567890",
      label = {
        after = false,
        before = true,
      },
      modes = {
        char = {
          highlight = { backdrop = false },
          -- Exclude some motion and operator
          label = { exclude = "ryipasdhjklxcvYPSDJKXCV" },
          keys = { "f", "F", "t", "T" },
          jump_labels = true,
          autohide = true,
          char_actions = function(motion)
            return {
              [";"] = "next",
              [","] = "prev",
              [motion:lower()] = "right",
              [motion:upper()] = "left",
            }
          end,
        },
        treesitter = {
          -- Extra exclude `o`
          label = { exclude = "ryiopasdhjklxcvYPSDJKXCV" },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["g"] = { name = "+Goto" },
        ["gs"] = {},
        ["]"] = { name = "+Next" },
        ["["] = { name = "+Prev" },
        ["<leader><tab>"] = { name = "+Switch Buffer" },
        ["<leader>t"] = { name = "+Tabs" },
        ["<leader>b"] = { name = "+Buffer" },
        ["<leader>c"] = { name = "" },
        ["<leader>l"] = { name = "+Language" },
        ["<leader>p"] = { name = "+Package Managers" },
        ["<leader>f"] = { name = "+Files" },
        ["<leader>g"] = { name = "+Git" },
        ["<leader>q"] = { name = "+Quit/Session" },
        ["<leader>s"] = { name = "+Search" },
        ["<leader>u"] = { name = "+UI" },
        ["<leader>w"] = { name = "+Windows" },
        ["<leader>x"] = { name = "+Diagnostics/Quickfix" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]g", gs.next_hunk, "Next Hunk")
        map("n", "[g", gs.prev_hunk, "Prev Hunk")
        map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map({ "o", "x" }, "ag", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map({ "n", "v" }, "<Leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<Leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<Leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<Leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<Leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<Leader>gp", gs.preview_hunk, "Preview Hunk")
        map("n", "<Leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<Leader>gd", gs.diffthis, "Diff This")
        map("n", "<Leader>gD", function() gs.diffthis("~") end, "Diff This ~")
      end,
    },
  },

  {
    "RRethy/vim-illuminate",
    opts = {
      delay = vim.o.timeoutlen,
    },
  },
}
