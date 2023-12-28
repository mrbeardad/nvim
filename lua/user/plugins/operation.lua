local utils = require("user.utils")

return {
  -- Modify surround objects
  {
    "echasnovski/mini.surround",
    keys = {
      { "ys", desc = "Add Surround" },
      { "s", ":<C-u>lua MiniSurround.add('visual')<CR>", mode = "x", desc = "Add Surround" },
      { "cs", desc = "Change Surround" },
      { "ds", desc = "Delete Surround" },
    },
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        replace = "cs", -- Replace surrounding
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        update_n_lines = "", -- Update `n_lines`
        suffix_next = "n", -- Suffix to search with "next" method
        suffix_last = "N", -- Suffix to search with "prev" method
      },
      search_method = "cover",
      n_lines = 100,
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.del("x", "ys")
    end,
  },

  -- Better yank/paste
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not utils.is_windows() } },
    keys = {
      {
        "<Leader>sy",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        desc = "Open Yank History",
      },
      {
        "<Leader>sp",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "Y", "<Plug>(YankyYank)$", mode = { "n", "x" }, desc = "Yank Text After Cursor" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (linewise)" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Selection" },
      { "zp", '"0<Plug>(YankyPutAfter)', mode = { "n", "x" }, desc = "Put Last Yanked Text After Cursor" },
      { "zP", '"0<Plug>(YankyPutBefore)', mode = { "n", "x" }, desc = "Put Last Yanked Text Before Cursor" },
      { "z]p", '"0<Plug>(YankyPutIndentAfterLinewise)', desc = "Put Indented After Cursor (linewise)" },
      { "z[p", '"0<Plug>(YankyPutIndentBeforeLinewise)', desc = "Put Indented Before Cursor (linewise)" },
      { "zgp", '"0<Plug>(YankyGPutAfter)', mode = { "n", "x" }, desc = "Put Last Yanked Text After Selection" },
      { "zgP", '"0<Plug>(YankyGPutBefore)', mode = { "n", "x" }, desc = "Put Last Yanked Text Before Selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
    },
    opts = {
      highlight = { timer = 150 },
      ring = { storage = utils.is_windows() and "shada" or "sqlite" },
    },
  },

  -- Multiple cursor to modify matched pattern
  {
    "mrbeardad/nvim-multi-cursor",
    keys = {
      { "<M-LeftMouse>", mode = { "n" } },
      { "mm", mode = { "n" } },
      { "mc", mode = { "n" } },
    },
    opts = {},
  },
}
