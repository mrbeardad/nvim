return {
  {
    "f-person/auto-dark-mode.nvim",
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("tokyonight")
    end,
    opts = {
      update_interval = 1000,
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
        hl.String.italic = true
        hl.Statement.bold = true
        hl.NeoTreeTabInactive = {
          link = "TabLine",
        }
        hl.NeoTreeTabSeparatorInactive = {
          link = "TabLine",
        }
        -- hl.ScrollbarHandle = {
        --   bg = lighten(hl.ScrollbarHandle.bg, 0.9),
        -- }
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
}
