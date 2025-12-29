local util = require("util")
return {
  -- Dashboard
  {
    "snacks.nvim",
    opts = function(plugin, opts)
      for _, key in ipairs(opts.dashboard.preset.keys) do
        if key.key == "g" then
          key.key = "/"
        elseif key.key == "s" then
          key.icon = " "
        end
      end
    end,
  },

  -- Explorer and Finder
  {
    "snacks.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          if not util.goto_explorer_window() then
            Snacks.explorer({ cwd = LazyVim.root() })
          end
        end,
        desc = "Explorer Snacks (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          if not util.goto_explorer_window() then
            Snacks.explorer()
          end
        end,
        desc = "Explorer Snacks (cwd)",
      },
      {
        "<C-p>",
        "<Leader>ff",
        desc = "Find Files (Root Dir)",
        remap = true,
      },
      {
        "<Leader>r",
        "<Leader>fr",
        desc = "Recent",
        remap = true,
      },
      {
        "<Leader>/",
        "<Leader>sw",
        desc = "Visual selection or word (Root Dir)",
        mode = { "x" },
        remap = true,
      },
      {
        "<C-`>",
        function()
          if not util.goto_terminal_window() then
            -- on windows, execute pwsh.exe directly may run the pwsh as unpackage app and case problem
            local cmd = LazyVim.is_win()
                and vim.env.LOCALAPPDATA .. "\\Microsoft\\WindowsApps\\Microsoft.PowerShell_8wekyb3d8bbwe\\pwsh.exe"
              or nil
            Snacks.terminal(cmd, { cwd = LazyVim.root(), win = { position = "bottom" }, auto_insert = false })
          end
        end,
        mode = { "n", "t" },
        desc = "Terminal (Root Dir)",
      },
    },
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-_>"] = { "toggle_help_input", mode = { "n", "i" } },
              ["<C-u>"] = false,
              ["<C-v>"] = false,
            },
          },
        },
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["o"] = "system_open",
                  ["<F2>"] = "explorer_rename",
                  ["<Tab>"] = false,
                  ["<S-Tab>"] = false,
                },
              },
            },
            actions = {
              system_open = function(picker, path)
                if not path.dir then
                  path = path.parent.file
                end
                util.open_in_system(path)
              end,
            },
          },
        },
      },

      styles = {
        input = {
          keys = {
            i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
          },
        },
      },

      notifier = {
        style = "fancy",
      },

      terminal = {
        win = {
          keys = {
            nav_h = false,
            nav_j = false,
            nav_k = false,
            nav_l = false,
            hide_slash = false,
            hide_underscore = false,
            hide = { "<C-`>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
          },
        },
      },
    },
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = function(plugin, events)
      return "LazyFile"
    end,
    keys = {
      {
        "<Leader>`",
        "<Cmd>BufferLinePick<CR>",
        desc = "Pick Buffer",
        mode = { "n" },
      },
    },
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_y = { "filetype", "fileformat", "encoding" },
        lualine_z = { { " %c  %l:%L", type = "stl" } },
      },
    },
  },

  -- Shortcut prompt
  {
    "folke/which-key.nvim",
    opts = function(plugin, opts)
      for _, group in ipairs(opts.spec[1]) do
        if group.group == "tabs" then
          group[1] = "<leader>t"
          break
        end
      end
      table.insert(opts.spec, { mode = { "n", "x" }, { { "<leader>m", group = "multi-cursor" } } })
    end,
  },

  -- Show context of the current cursor position
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    keys = {
      {
        "[]",
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

  -- Highlight different level brackets with different color
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
  },

  -- Highlight matched bracket
  {
    "monkoose/matchparen.nvim",
    event = "LazyFile",
    opts = {},
  },

  -- Highlight undo/redo change
  {
    "tzachar/highlight-undo.nvim",
    event = "LazyFile",
    opts = {},
    vscode = true,
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        -- set the dark theme colors, and tokyonight will invert the colors for light theme automatically
        local lighten = require("tokyonight.util").lighten
        local darken = require("tokyonight.util").darken
        hl.String.italic = true
        hl.Statement.bold = true
        hl.MatchParen = {
          bg = lighten(hl.CursorLine.bg, 0.7),
          bold = true,
          italic = true,
        }
        --hl.FlashLabel = {
        --  fg = lighten(hl.FlashLabel.fg, 0.1),
        --  bg = hl.FlashLabel.bg,
        --  bold = true,
        --  italic = true,
        --}
        --hl.FlashLabelUnselected = {
        --  fg = darken(hl.FlashLabel.fg, 0.7),
        --  bg = darken(hl.FlashLabel.bg, 0.7),
        --  bold = true,
        --  italic = true,
        --}
        --hl.YankyPut = {
        --  link = "Search",
        --}
        --hl.YankyYanked = {
        --  link = "Search",
        --}
      end,
    },
  },
}
