local keymap = require("user.utils.keymap")
local utils = require("user.utils")

return {
  -- Modify surround objects
  {
    "echasnovski/mini.surround",
    keys = {
      { "ys", desc = "Add Surround" },
      { "s", ":<C-U>lua MiniSurround.add('visual')<CR>", mode = "x", desc = "Add Surround" },
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
    dependencies = { "kkharji/sqlite.lua" },
    init = function()
      if utils.is_windows() then
        vim.g.sqlite_clib_path = "winsqlite3.dll"
      end
    end,
    -- stylua: ignore
    keys = {
      { "<Leader>sy", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Open Yank History" },
      { "<Leader>sp", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "Y", "<Plug>(YankyYank)$", mode = { "n", "x" }, desc = "Yank Text After Cursor" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
      { "gp", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (linewise)" },
      { "gP", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (linewise)" },
      { "zp", '"0<Plug>(YankyPutAfter)', mode = { "n", "x" }, desc = "Put Last Yanked Text After Cursor" },
      { "zP", '"0<Plug>(YankyPutBefore)', mode = { "n", "x" }, desc = "Put Last Yanked Text Before Cursor" },
      { "zgp", '"0<Plug>(YankyPutIndentAfterLinewise)', mode = { "n", "x" }, desc = "Put Last Yanked Text After Selection" },
      { "zgP", '"0<Plug>(YankyPutIndentBeforeLinewise)', mode = { "n", "x" }, desc = "Put Last Yanked Text Before Selection" },
      { "[p", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]p", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
    },
    opts = {
      highlight = { timer = 150 },
      ring = { storage = "sqlite" },
    },
  },

  -- Multiple cursor to modify matched pattern
  {
    "mrbeardad/nvim-multi-cursor",
    keys = {
      {
        "<C-J>",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_downward()
        end,
        mode = { "n" },
        desc = "Add Cursor Downward",
      },
      {
        "<C-S-J>",
        function()
          require("nvim-multi-cursor.cursor").cursor_down()
        end,
        mode = { "n" },
        desc = "Move Cursor Down",
      },
      {
        "<C-K>",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_upward()
        end,
        mode = { "n" },
        desc = "Add Cursor Upward",
      },
      {
        "<C-S-K>",
        function()
          require("nvim-multi-cursor.cursor").cursor_up()
        end,
        mode = { "n" },
        desc = "Move Cursor Up",
      },
      {
        "<C-N>",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_next_match()
        end,
        mode = { "n", "x" },
        desc = "Add Cursor Upward",
      },
      {
        "<C-S-N>",
        function()
          require("nvim-multi-cursor.cursor").cursor_next_match()
        end,
        mode = { "n" },
        desc = "Move Cursor Up",
      },
      {
        "<C-S-L>",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_all_match()
        end,
        mode = { "n" },
        desc = "Move Cursor Up",
      },
      {
        "<Leader>mw",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_by_flash([[\<\w*\>]])
        end,
        mode = { "n" },
        desc = "Selection Wrod To Add Cursor",
      },
      {
        "<Leader>ms",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_by_flash()
        end,
        mode = { "n" },
        desc = "Selection To Add Cursor",
      },
    },
    opts = {},
  },

  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    lazy = true,
    opts = {
      default_mappings = false,
    },
    -- cond = not not vim.g.vscode,
  },
}
