return {
  {
    "f-person/auto-dark-mode.nvim",
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("tokyonight")
    end,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", { scope = "global" })
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", { scope = "global" })
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      -- style = "moon",
      dim_inactive = true,
      styles = {
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "normal", -- style for floating windows
      },
      on_highlights = function(hl, c)
        -- set the dark theme colors, and tokyonight will invert the colors for light theme automatically
        local lighten = require("tokyonight.util").lighten
        local darken = require("tokyonight.util").darken
        hl.NeoTreeTabInactive = {
          link = "TabLine",
        }
        hl.NeoTreeTabSeparatorInactive = {
          link = "TabLine",
        }
        hl.ScrollbarHandle = {
          bg = lighten(hl.ScrollbarHandle.bg, 0.9),
        }
        hl.MatchParen = {
          fg = hl.MatchParen.fg,
          bg = hl.IlluminatedWordText.bg,
          bold = true,
          italic = true,
        }
        hl.FlashLabel = {
          fg = lighten(hl.FlashLabel.fg, 0.1),
          bg = hl.FlashLabel.bg,
          bold = true,
          italic = true,
        }
        hl.FlashLabelUnselected = {
          fg = darken(hl.FlashLabel.fg, 0.7),
          bg = darken(hl.FlashLabel.bg, 0.7),
          bold = true,
          italic = true,
        }
        hl.YankyPut = {
          link = "Search",
        }
        hl.YankyYanked = {
          link = "Search",
        }
      end,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "macchiato",
      },
      dim_inactive = {
        enabled = true,
      },
      custom_highlights = function(colors)
        return {
          MatchParen = { italic = true },
        }
      end,
      integrations = {
        aerial = false,
        alpha = true,
        barbar = false,
        beacon = false,
        -- bufferline
        cmp = true,
        coc_nvim = false,
        dap = false,
        dap_ui = false,
        dashboard = false,
        dropbar = {
          enabled = false,
          color_mode = false, -- enable color for kind's texts, not just kind's icons
        },
        -- feline
        fern = false,
        fidget = false,
        flash = true,
        gitgutter = false,
        gitsigns = true,
        harpoon = false,
        headlines = false,
        hop = false,
        illuminate = {
          enabled = true,
          lsp = false,
        },
        indent_blankline = {
          enabled = true,
          scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        leap = false,
        lightspeed = false,
        lsp_saga = false,
        lsp_trouble = false,
        -- lualine
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
        navic = {
          enabled = false,
          custom_bg = "NONE", -- "lualine" will set background to mantle
        },
        neogit = false,
        neotest = false,
        neotree = true,
        noice = true,
        notifier = false,
        notify = true,
        nvimtree = false,
        octo = false,
        overseer = false,
        pounce = false,
        rainbow_delimiters = true,
        sandwich = false,
        semantic_tokens = true,
        symbols_outline = false,
        telekasten = false,
        telescope = {
          enabled = true,
          -- style = "nvchad"
        },
        treesitter = true,
        treesitter_context = true,
        ts_rainbow = false,
        ts_rainbow2 = false,
        ufo = false,
        vim_sneak = false,
        vimwiki = false,
        which_key = true,
        window_picker = false,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      if vim.g.colors_name:find("catppuccin", 1, true) then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end
    end,
  },
}
