local keymap = require("user.utils.keymap")
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
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
      { "[p", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]p", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
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
      {
        "<C-j>",
        function()
          require("nvim-multi-cursor").toggle_cursor_downward()
        end,
        mode = { "n" },
        desc = "Add Cursor",
      },
      {
        "<C-k>",
        function()
          require("nvim-multi-cursor").toggle_cursor_upward()
        end,
        mode = { "n" },
        desc = "Add Cursor",
      },
      {
        "<Leader>ms",
        function()
          require("nvim-multi-cursor").toggle_cursor_by_flash()
        end,
        mode = { "n" },
        desc = "Selection To Add Cursor",
      },
      {
        "<Leader>mw",
        function()
          require("nvim-multi-cursor").toggle_cursor_by_flash(vim.fn.expand("<cword>"))
        end,
        mode = { "n" },
        desc = "Selection Wrod To Add Cursor",
      },
    },
    opts = {},
  },

  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    keys = {
      {
        "I",
        function()
          require("vscode-multi-cursor").start_left({ no_selection = true })
        end,
        mode = "x",
      },
      {
        "I",
        function()
          if #require("vscode-multi-cursor.state").cursors == 0 then
            return "I"
          end
          require("vscode-multi-cursor").start_left()
          return "<Ignore>"
        end,
        mode = "n",
        expr = true,
      },
      {
        "A",
        function()
          require("vscode-multi-cursor").start_right({ no_selection = true })
        end,
        mode = "x",
      },
      {
        "A",
        function()
          if #require("vscode-multi-cursor.state").cursors == 0 then
            return "A"
          end
          require("vscode-multi-cursor").start_right()
          return "<Ignore>"
        end,
        mode = "n",
        expr = true,
      },
      {
        "c",
        function()
          if vim.fn.mode() == "\x16" then
            require("vscode-multi-cursor").start_right()
            require("vscode-neovim").action("deleteLeft")
            return "<Ignore>"
          else
            return "c"
          end
        end,
        expr = true,
        mode = "x",
      },
      {
        "<Leader>m",
        function()
          return require("vscode-multi-cursor").create_cursor()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Create cursor",
      },
      -- {
      --   "mcs",
      --   function()
      --     require("vscode-multi-cursor").flash_char()
      --   end,
      --   mode = "n",
      --   desc = "Create cursor using flash",
      -- },
      -- {
      --   "mcw",
      --   function()
      --     require("vscode-multi-cursor").flash_word()
      --   end,
      --   mode = "n",
      --   desc = "Create selection using flash",
      -- },
      {
        "<Esc>",
        function()
          if #require("vscode-multi-cursor.state").cursors ~= 0 then
            require("vscode-multi-cursor").cancel()
          else
            vim.cmd("normal! \27")
          end
        end,
        mode = "n",
        desc = "Cancel/Clear all cursors",
      },
      {
        "[m",
        function()
          require("vscode-multi-cursor").prev_cursor()
        end,
        mode = "n",
        desc = "Goto prev cursor",
      },
      {
        "]m",
        function()
          require("vscode-multi-cursor").next_cursor()
        end,
        mode = "n",
        desc = "Goto next cursor",
      },
      {
        "<C-n>",
        function()
          require("vscode-multi-cursor").addSelectionToNextFindMatch()
        end,
        mode = { "n", "x", "i" },
        desc = "Select Next Find Match",
      },
    },
    opts = {
      default_mappings = false,
    },
    cond = not not vim.g.vscode,
  },
}
