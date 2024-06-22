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
        "<C-J>",
        function()
          require("nvim-multi-cursor.cursor").toggle_cursor_downward()
        end,
        mode = { "n" },
        desc = "Add Cursor Downward",
      },
      {
        "<C-S-j>",
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
        "<C-S-k>",
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
        mode = { "n" },
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
        mode = "x",
        expr = true,
      },
      {
        "<Leader>m",
        function()
          return require("vscode-multi-cursor").create_cursor()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Create Cursor",
      },
      -- {
      --   "<Leader>ms",
      --   function()
      --     if vim.api.nvim_get_hl(0, { name = "FlashLabelUnselected" }).bg == nil then
      --       vim.api.nvim_set_hl(
      --         0,
      --         "FlashLabelUnselected",
      --         { fg = "#b9bbc4", bg = "#bd0c69", italic = true, bold = true }
      --       )
      --     end
      --     keymap.toggle_cursor_by_flash()
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
            return "<Ignore>"
          else
            return "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR><Esc>"
          end
        end,
        expr = true,
        mode = "n",
        desc = "Cancel/Clear All Cursors",
      },
      {
        "[m",
        function()
          require("vscode-multi-cursor").prev_cursor()
        end,
        mode = "n",
        desc = "Goto Prev Cursor",
      },
      {
        "]m",
        function()
          require("vscode-multi-cursor").next_cursor()
        end,
        mode = "n",
        desc = "Goto Next Cursor",
      },
      {
        "<C-N>",
        function()
          require("vscode-multi-cursor").addSelectionToNextFindMatch()
        end,
        mode = { "n", "x", "i" },
        desc = "Select Next Find Match",
      },
      {
        "<C-S-l>",
        function()
          require("vscode-multi-cursor").selectHighlights()
        end,
        mode = { "n", "x", "i" },
        desc = "Select All Find Match",
      },
    },
    opts = {
      default_mappings = false,
    },
    cond = not not vim.g.vscode,
  },
  {
    "keaising/im-select.nvim",
    ft = { "markdown" },
    config = function()
      require("im_select").setup({})
    end,
    enabled = false,
  },
}
