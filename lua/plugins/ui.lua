return {
  -- ui: bufferline
  {
    "akinsho/bufferline.nvim",
    event = function()
      return { "LazyFile" }
    end,
    keys = {
      { "<Leader>`", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
      { "<Leader>bD", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" },
      { "<Leader>bE", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" },
      { "<Leader>br", false },
      { "<Leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers To The Left" },
      { "<Leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers To The Right" },
    },
    opts = {
      options = {
        always_show_bufferline = true,
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

  -- ui: statusline
  {
    "nvim-lualine/lualine.nvim",
    event = function()
      return { "LazyFile" }
    end,
    opts = {
      sections = {
        lualine_y = { "fileformat", "encoding" },
        lualine_z = { { " %c  %l:%L", type = "stl" } },
      },
    },
  },

  -- ui: startup page
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- Header
      local banners = require("user.banners")
      math.randomseed(os.time())
      local banner = vim.split(banners[math.random(#banners)], "\n")
      opts.section.header.val = banner
      -- Buttons
      local dashboard = require("alpha.themes.dashboard")
      opts.section.buttons.val = {
        dashboard.button("n", "  New File", "<cmd>ene<Bar>startinsert<cr>"),
        dashboard.button("/", "󱎸  Find Text", "<cmd>Telescope egrepify<cr>"),
        dashboard.button("f", "󰈞  Find File", "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("c", "  Config", "<cmd>lua require('lazyvim.util').telescope.config_files()()<cr>"),
        dashboard.button("s", "󰦛  Restore Session", "<cmd>lua require('persistence').load()<cr>"),
        dashboard.button("x", "  Lazy Extras", "<cmd>LazyExtras<cr>"),
        dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }
      -- Vertical center the header
      local remain_height = vim.api.nvim_win_get_height(0) - #banner - #opts.section.buttons.val * 2 - 2
      remain_height = remain_height > 0 and remain_height or 0
      opts.opts.layout[1].val = math.ceil(remain_height / 2)
      opts.opts.layout[3].val = math.floor(remain_height / 2)
      -- Highlight
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
    end,
  },

  -- ui: animate
  -- {
  --   "echasnovski/mini.animate",
  --   opts = {
  --     cursor = { enable = false },
  --   },
  -- },

  -- ui: scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "LazyFile",
    opts = {
      -- show_in_active_only = true, -- This will cause blink
      hide_if_all_visible = true,
      handle = {
        highlight = "ScrollbarHandle",
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        search = false, -- Requires hlslens
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
}
